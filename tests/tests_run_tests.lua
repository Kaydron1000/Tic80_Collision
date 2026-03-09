-- Simple Lua test runner (no external deps)
-- Run: lua tests/run_tests.lua

local function fail(msg)
  io.stderr:write("FAIL: " .. msg .. "\n")
  os.exit(1)
end

local function assertEq(actual, expected, msg)
  if actual ~= expected then
    fail((msg or "assertEq failed") .. ("\n  expected: %s\n  actual:   %s"):format(tostring(expected), tostring(actual)))
  end
end

local function assertTrue(v, msg)
  if not v then fail(msg or "assertTrue failed") end
end

-- ---- TIC-80 stubs (so your src files load in plain Lua)
_G.trace = _G.trace or function(_) end
_G.print = _G.print or print
_G.TICK_CNT = _G.TICK_CNT or 0
_G.CELL = _G.CELL or 16

-- Load game code (adjust if you move files later)
dofile("src/collisions.lua")

-- ---- Tests

-- Test MirrorHit
do
  local hit = { t_entry=0.25, t_exit=0.75, enx=1, eny=-1, xnx=1, xny=-1 }
  local m = MirrorHit(hit)
  assertEq(m.t_entry, 0.25, "MirrorHit t_entry")
  assertEq(m.t_exit, 0.75, "MirrorHit t_exit")
  assertEq(m.enx, -1, "MirrorHit enx")
  assertEq(m.eny, 1, "MirrorHit eny")
  assertEq(m.xnx, -1, "MirrorHit xnx")
  assertEq(m.xny, 1, "MirrorHit xny")
end

-- Helpers to build AABBs like your code expects
local function box(x, y, xl, xr, yt, yb, dx, dy)
  return { x=x, y=y, xl=xl, xr=xr, yt=yt, yb=yb, dx=dx or 0, dy=dy or 0 }
end

-- Test AABB_axis / AABB: no overlap
do
  local a = box(0, 0, 0, 10, 0, 10)
  local b = box(30, 0, 0, 10, 0, 10)
  local c = AABB_axis(a, b)
  assertEq(c.x, AXIS_NONE, "AABB_axis x none")
  assertEq(AABB(a, b), NONE, "AABB NONE when separated")
end

-- Test AABB: touching
do
  local a = box(0, 0, 0, 10, 0, 10)
  local b = box(10, 0, 0, 10, 0, 10) -- touches at x=10
  assertEq(AABB(a, b), TOUCHING, "AABB TOUCHING when edges meet")
end

-- Test Swept_aabb: moving into a block from left
do
  local a = box(0, 0, 0, 10, 0, 10, 20, 0)     -- moves right by 10
  local b = box(25, 0, 0, 10, 0, 10, 0, 0)     -- static block
  local hit = Swept_aabb(a, b)
  assertTrue(hit ~= nil, "Swept_aabb should detect a hit")

  -- a right edge starts at 10, b left edge is 25 => gap 15, dx=10 => entry time 1.5 => should be nil
  -- Wait: with these numbers it SHOULD NOT hit within 1 frame.
  -- Let's correct to make it hit: set b at x=18 => gap 8, dx=10 => t_entry=0.8
end

do
  local a = box(0, 0, 0, 10, 0, 10, 10, 0)
  local b = box(18, 0, 0, 10, 0, 10, 0, 0)
  local hit = Swept_aabb(a, b)
  assertTrue(hit ~= nil, "Swept_aabb should detect a hit (within frame)")
  assertTrue(hit.t_entry >= 0 and hit.t_entry <= 1, "t_entry should be within [0,1]")
  assertEq(hit.enx, -1, "Expected collision normal enx = -1 (hit b from left)")
end

print("OK: all tests passed")