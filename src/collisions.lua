---------
NONE=1
TOUCHING=2
ENGULF=4
INTERSECTING=8
AXIS_NONE=16
AXIS_TOUCHING=32
AXIS_CONTAINS=64
AXIS_OVERLAP=128
_CheckedPair= {}
function MirrorHit(hit)
  if not hit then return nil end
  return {
    t_entry = hit.t_entry,
    t_exit = hit.t_exit,
    enx = -hit.enx,
    eny = -hit.eny,
    xnx = -hit.xnx,
    xny = -hit.xny
  }
end
------------------------
function Check_collisions(sprites, nextState)
  _CheckedPair = {}
  -- Clear events for check
  for i=1,#sprites do
    local o = sprites[i]

    if nextState then
      o.eventsNext = {}
    else
      o.eventsCurr = {}
    end
  end
  -- Check collisions
  for i = 1, #sprites do
    local o = sprites[i]
    if o.alive then
      Check_collision(i, o, nextState)
    end
  end
end
------------------------
function Check_collision(i, a, nextState)
 if nextState == nil then nextState = true end
 local minx,maxx,miny,maxy,grid,eventsA,eventsB

  if nextState then
    eventsA=a.eventsNext
    minx =math.floor((a.x + a.dx + a.xl) / CELL)
    maxx =math.floor((a.x + a.dx + a.xr) / CELL)
    miny =math.floor((a.y + a.dy + a.yt) / CELL)
    maxy =math.floor((a.y + a.dy + a.yb) / CELL)
    grid=_Grid_next
  else
    eventsA=a.eventsCurr
    minx =math.floor((a.x + a.xl) / CELL)
    maxx =math.floor((a.x + a.xr) / CELL)
    miny =math.floor((a.y + a.yt) / CELL)
    maxy =math.floor((a.y + a.yb) / CELL)
    grid=_Grid_curr
  end
  local checked = {}
  for y = miny, maxy do
    for x = minx, maxx do
      local k = Grid_key(x, y)
      local cell = grid[k]
      for _, j in ipairs(cell) do
        if j ~= i and not _CheckedPair[i..j] then --if j ~= i and not checked[j] and not _CheckedPair[i..j] then
          checked[j] = true
          _CheckedPair[i..j]=true
          _CheckedPair[j..i]=true

          local b = Sprites[j]
          if nextState then
            eventsB=b.eventsNext
          else
            eventsB=b.eventsCurr
          end

          local hita, hitb
          local xLoc=172
          if nextState then
            hita = Swept_aabb(a, b)
            hitb = MirrorHit(hita)
            eventsA[b] = {hit=hita, spriteHit=b}
            eventsB[a] = {hit=hitb, spriteHit=a}
            --HitReactions(a, b, hit)
            print("NEXT FRAME::",xLoc,1,6)
            if hita then
              print("t_entry:"..hita.t_entry,xLoc,8,6)
              print("enx:"..hita.enx,xLoc,16,6)
              print("eny:"..hita.eny,xLoc,24,6)
              print("t_exit:"..hita.t_exit,xLoc,40,6)
              print("xnx:"..hita.xnx,xLoc,48,6)
              print("xny:"..hita.xny,xLoc,56,6)
            else
              print("NO HIT",xLoc,64,6)
            end
          else
            hita = AABB(a, b)
            hitb = hita
            
            eventsA[b] = {hit=hita, spriteHit=b}
            eventsB[a] = {hit=hitb, spriteHit=a}
            xLoc=100
            print("CURR FRAME::",xLoc,1,6)
            print("AABB STATE:"..hita,xLoc,8,6)
          end
        end
      end
    end
  end
end
------------------------

------------------------
function AABB(a,b)
  local c = AABB_axis(a, b)
  local state
  if c.x == AXIS_NONE or c.y == AXIS_NONE then
    state = NONE
  elseif c.x == AXIS_TOUCHING or c.y == AXIS_TOUCHING then
    state = TOUCHING
  elseif c.x == AXIS_CONTAINS and c.y == AXIS_CONTAINS then
    state = ENGULF
  else
    state = INTERSECTING
  end
  return state
end
------------------------
function AABB_axis(a, b)
  local al = a.x + a.xl
  local ar = a.x + a.xr
  local at = a.y + a.yt
  local ab = a.y + a.yb

  local bl = b.x + b.xl
  local br = b.x + b.xr
  local bt = b.y + b.yt
  local bb = b.y + b.yb

  local function axisState(minA, maxA, minB, maxB)
    if maxA < minB or minA > maxB then
      return AXIS_NONE
    end
    if maxA == minB or minA == maxB then
      return AXIS_TOUCHING
    end
    if minA <= minB and maxA >= maxB then
      return AXIS_CONTAINS
    end
    if minB <= minA and maxB >= maxA then
      return AXIS_CONTAINS
    end
    return AXIS_OVERLAP
  end

  return {
    x = axisState(al, ar, bl, br),
    y = axisState(at, ab, bt, bb)
  }
end

-----------------------
function Swept_aabb(a, b)
  local dx = a.dx - b.dx
  local dy = a.dy - b.dy

  if dx == 0 and dy == 0 then return nil end

  -- bounds
  local axl, axr = a.x + a.xl, a.x + a.xr
  local ayt, ayb = a.y + a.yt, a.y + a.yb
  local bxl, bxr = b.x + b.xl, b.x + b.xr
  local byt, byb = b.y + b.yt, b.y + b.yb

  local x_entry, x_exit
  local y_entry, y_exit

  -- X axis
  if dx > 0 then
    x_entry = bxl - axr
    x_exit  = bxr - axl
  elseif dx < 0 then
    x_entry = bxr - axl
    x_exit  = bxl - axr
  else
    -- NO X motion -> must already overlap
    if axr <= bxl or axl >= bxr then return nil end
    x_entry = -math.huge
    x_exit  =  math.huge
  end

  -- Y axis
  if dy > 0 then
    y_entry = byt - ayb
    y_exit  = byb - ayt
  elseif dy < 0 then
    y_entry = byb - ayt
    y_exit  = byt - ayb
  else
    -- NO Y motion -> must already overlap
    if ayb <= byt or ayt >= byb then return nil end
    y_entry = -math.huge
    y_exit  =  math.huge
  end

  local tx_entry = x_entry / dx
  local tx_exit  = x_exit  / dx
  local ty_entry = y_entry / dy
  local ty_exit  = y_exit  / dy

  local t_entry = math.max(tx_entry, ty_entry)
  local t_exit  = math.min(tx_exit, ty_exit)

  if t_exit < 0 then
    return nil
  end

  if tx_entry < 0 and ty_entry < 0 then
    return nil
  end

  -- If already overlapxLocng (t_entry < 0), clamp to 0 and handle it
  if t_entry < 0 then
    t_entry = 0
  end

  if t_entry > 1 or t_entry > t_exit then
    return nil
  end

  -- collision normal
 local enx, eny, xnx, xny = 0, 0, 0, 0
 if tx_entry > ty_entry then
   enx = dx > 0 and -1 or 1
 else
   eny = dy > 0 and -1 or 1
 end
 if tx_exit < ty_exit then
   xnx = dx < 0 and -1 or 1
 else
   xny = dy < 0 and -1 or 1
 end

  trace('TICK_CNT='..TICK_CNT.."  t_entry="..t_entry.."  enx="..enx.."  eny="..eny)
  return {
   t_entry=t_entry,
   t_exit=t_exit,
   enx = enx,
   eny = eny,
   xnx = xnx,
   xny = xny
 }
end