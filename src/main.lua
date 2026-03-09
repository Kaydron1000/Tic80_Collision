--#define DEBUG true
---------
--#include "actions.lua"
--#include "collisions.lua"
--#include "grid.lua"
--#include "reactions.lua"
TICK_CNT=0
VIEW_XMIN=0
VIEW_YMIN=0
VIEW_XMAX=240
VIEW_YMAX=136
---------
ANIM_STATIC = 1
ANIM_LEFT   = 2
ANIM_RIGHT  = 4
ANIM_UP     = 8
ANIM_DOWN   = 16
ANIM_DIE    = 32
---------
LAY_WORLD_STATIC   = 1
LAY_WORLD_DYNAMIC  = 2
LAY_WORLD_BG       = 4
LAY_SFX            = 8
LAY_PLAYERS        = 16
LAY_ITEM           = 32
LAY_BOMBS          = 64
LAY_EXPLOSION      = 128

---------
Sprites={}
UsersKeyMap={
 {  0, -1, -2, -3, -4, -5, -6, -7},
 { -8, -9,-10,-11,-12,-13,-14,-15},-- 9,11,10,12--I,K,J,L
 {-16,-17,-18,-19,-20,-21,-22,-23},
 {-24,-25,-26,-27,-28,-29,-30,-31}
}

function ClampTowardZero(v)
	if v > 0 then
		return math.floor(v)
	elseif v < 0 then
		return math.ceil(v)
	end
	return 0
end

function Init()
 TICK_CNT=1
 Sprites[1]={
	sIdx=1,
	layer=LAY_PLAYERS,
	eventsNext={},
	eventsCurr={},
	alive=true,
	x=48,
	y=48,
	dx=0,
	dy=0,
	a1=false,
	a2=false,
	a3=false,
	a4=false,
	spd=1,
	xl=-4,
	xr=4,
	yt=-4,
	yb=4,
	Action=function (self)
		PlayerControl(self, UsersKeyMap[self.sIdx])
	end,
	Reaction=function(self)
		PlayerReaction(self)
	end,
 }
 Sprites[2]={
	sIdx=2,
	layer=LAY_WORLD_STATIC,
	eventsNext={},
	eventsCurr={},
	alive=true,
	x=64,
	y=20,
	dx=0,
	dy=0,
	a1=false,
	a2=false,
	a3=false,
	a4=false,
	xl=-24,
	xr=24,
	yt=-4,
	yb=4,
	Action=function (self)
	end,
	Reaction=function(self)
	end,
 }
 Sprites[3]={
	sIdx=3,
	layer=LAY_WORLD_STATIC,
	eventsNext={},
	eventsCurr={},
	alive=true,
	x=20,
	y=64,
	dx=0,
	dy=0,
	a1=false,
	a2=false,
	a3=false,
	a4=false,
	xl=-4,
	xr=4,
	yt=-24,
	yb=24,
	Action=function (self)
	end,
	Reaction=function(self)
	end,
 }
 Sprites[4]={
	sIdx=4,
	layer=LAY_WORLD_STATIC,
	eventsNext={},
	eventsCurr={},
	alive=true,
	x=40,
	y=84,
	dx=0,
	dy=0,
	a1=false,
	a2=false,
	a3=false,
	a4=false,
	xl=-16,
	xr=16,
	yt=-4,
	yb=4,
	Action=function (self)
	end,
	Reaction=function(self)
	end,
 }
 Sprites[5]={
	sIdx=5,
	layer=LAY_WORLD_STATIC,
	eventsNext={},
	eventsCurr={},
	alive=true,
	x=40,
	y=68,
	dx=0,
	dy=0,
	a1=false,
	a2=false,
	a3=false,
	a4=false,
	xl=-16,
	xr=16,
	yt=-4,
	yb=4,
	Action=function (self)
	end,
	Reaction=function(self)
	end,
 }
 Sprites[6]={
	sIdx=6,
	layer=LAY_WORLD_DYNAMIC,
	eventsNext={},
	eventsCurr={},
	alive=true,
	x=140,
	y=20,
	dx=0,
	dy=0,
	a1=false,
	a2=false,
	a3=false,
	a4=false,
	xl=-4,
	xr=4,
	yt=-4,
	yb=4,
	Action=function (self)
	end,
	Reaction=function(self)
		BlockReaction(self)
	end,
 }
 Sprites[7]={
	sIdx=7,
	layer=LAY_WORLD_DYNAMIC,
	eventsNext={},
	eventsCurr={},
	alive=true,
	x=80,
	y=70,
	dx=0,
	dy=0,
	a1=false,
	a2=false,
	a3=false,
	a4=false,
	xl=-4,
	xr=4,
	yt=-4,
	yb=4,
	Action=function (self)
	end,
	Reaction=function(self)
		BlockReaction(self)
	end,
 }
 Sprites[8]={
	sIdx=8,
	layer=LAY_WORLD_DYNAMIC,
	eventsNext={},
	eventsCurr={},
	alive=true,
	x=148,
	y=50,
	dx=0,
	dy=0,
	a1=false,
	a2=false,
	a3=false,
	a4=false,
	xl=-8,
	xr=8,
	yt=-8,
	yb=8,
	Reaction=function(self)
		BlockReaction(self)
	end,
 }
end

Init()

function TIC()
	TICK_CNT=TICK_CNT+1
	--trace("------------------------")
	--trace("TICK: "..TICK_CNT)
	--trace("------------------------")
	cls(0)
	--Grid_Current
	--Action
	--Grid_Next
	--Reaction
	--Draw
	for i=1,#Sprites do
		local s = Sprites[i]
		s.dx=0
		s.dy=0
	end
	BuildCurrentGrid(Sprites)
	Check_collisions(Sprites, false)
	Actions(nil,Sprites)
	BuildNextGrid(Sprites)
	Check_collisions(Sprites, true)
	for i=1,#Sprites do
		local s = Sprites[i]
		
		s:Reaction()
	end
	--Reactions()
	DrawSprites()
	print("DYN - EventsNext: "..#Sprites[8].eventsNext)
	print("S1 - X:"..Sprites[1].x.." Y:"..Sprites[1].y,5,VIEW_YMAX-16,6)
	print("S1 - DX:"..Sprites[1].dx.." DY:"..Sprites[1].dy,5,VIEW_YMAX-8,12)
	
	print("S2 - X:"..Sprites[2].x.." Y:"..Sprites[2].y,85,VIEW_YMAX-16,6)
	print("S2 - DX:"..Sprites[2].dx.." DY:"..Sprites[2].dy,85,VIEW_YMAX-8,12)

	print("S3 - X:"..Sprites[3].x.." Y:"..Sprites[3].y,165,VIEW_YMAX-16,6)
	print("S3 - DX:"..Sprites[3].dx.." DY:"..Sprites[3].dy,165,VIEW_YMAX-8,12)
end
function DrawSprites()
	for i=1,#Sprites do
		DrawSprite(Sprites[i])
	end
end
function DrawSprite(s)
	local w=math.abs(s.xr)+math.abs(s.xl)
	local h=math.abs(s.yb)+math.abs(s.yt)
	w=s.xr-s.xl
	h=s.yb-s.yt
	if s.layer&LAY_PLAYERS>0 then
		rect(s.x+s.xl,s.y+s.yt,w,h,11)
		rect(s.x,s.y,1,1,6)
	elseif s.layer&LAY_WORLD_STATIC>0 then
		rect(s.x+s.xl,s.y+s.yt,w,h,10)
		rect(s.x,s.y,1,1,6)
	elseif s.layer&LAY_WORLD_DYNAMIC>0 then
		rect(s.x+s.xl,s.y+s.yt,w,h,9)
		rect(s.x,s.y,1,1,6)
	end
end