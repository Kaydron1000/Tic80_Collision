CELL = 16 -- or 32
_Grid_curr  = {}
_Grid_next  = {}
------------------------
function BuildCurrentGrid(sprites)
 Grid_curr_clear()
 for i = 1, #sprites do
  local o = sprites[i]
  if o.alive then
   Grid_insert(i, o, false)
  end
 end
end
------------------------
function BuildNextGrid(sprites)
 Grid_next_clear()
 for i = 1, #sprites do
  local o = sprites[i]
  if o.alive then
   Grid_insert(i, o, true)
  end
 end
end
-----------------------
function Grid_curr_clear()
 _Grid_curr = {}
end
-----------------------
function Grid_next_clear()
 _Grid_next = {}
end
-----------------------
function Grid_key(cx, cy)
 return cx .. "," .. cy
end
-----------------------
function Grid_insert(i, o, nextState)
 if nextState == nil then nextState = true end
 local minx,maxx,miny,maxy,grid
 
 if nextState then
  minx =math.floor((o.x+o.dx + o.xl) / CELL)
  maxx =math.floor((o.x+o.dx + o.xr) / CELL)
  miny =math.floor((o.y+o.dy + o.yt) / CELL)
  maxy =math.floor((o.y+o.dy + o.yb) / CELL)
  grid=_Grid_next
 else
  minx =math.floor((o.x+o.xl) / CELL)
  maxx =math.floor((o.x+o.xr) / CELL)
  miny =math.floor((o.y+o.yt) / CELL)
  maxy =math.floor((o.y+o.yb) / CELL)
  grid=_Grid_curr
 end
 for y = miny, maxy do
  for x = minx, maxx do
   local k = Grid_key(x, y)
   grid[k] = grid[k] or {}
   local idx=#grid[k]+1
   grid[k][idx] = i
  end
 end
end