
function Bounce(t, max)
 if max==1 then return 1 end
 
 local m = t % (2*max-2)
 return max - math.abs(m - (max-1))
end

function SpeedAdjust(t, spd)
	if spd<=1 then
		local a = math.floor(1/spd + 0.5)
		local currBounce = Bounce(t, a)
		if currBounce==a then
			return 1
		else
			return 0
		end
	else
		return spd
	end
end

function Actions(grid, sprites)
 for idx=1,#sprites do
  local s=sprites[idx]
  if     s.layer&LAY_BOMBS>0 then
  elseif s.layer&LAY_EXPLOSION>0 then
  elseif s.layer&LAY_ITEM>0 then

  elseif s.layer&LAY_WORLD_BG>0 then
  elseif s.layer&LAY_WORLD_DYNAMIC>0 then
  elseif s.layer&LAY_WORLD_STATIC>0 then
  end
 end
 UsersControl(sprites[1])--(Sprites[1],Sprites[2],Sprites[3],Sprites[4])
end

function UsersControl(s1)--(s1,s2,s3,s4)
 PlayerControl(s1,UsersKeyMap[1])
 --PlayerControl(s2,UsersKeyMap[2])
 --PlayerControl(s3,UsersKeyMap[3])
 --PlayerControl(s4,UsersKeyMap[4])
end
------------------------
function PlayerControl(s1,keyMap)
 local u=keyMap[1]
 local d=keyMap[2]
 local l=keyMap[3]
 local r=keyMap[4]
 local a=keyMap[5]
 local b=keyMap[6]
 local x=keyMap[7]
 local y=keyMap[8]
 
 s1.dy=0
 s1.dx=0
 s1.spd=1
 s1.a1=false
 s1.a2=false
 s1.a3=false
 s1.a4=false
 
 local bttnSpd=1
 local spd=1

 local q=u -- up
 if q <=0 then if btnp(q*-1,bttnSpd,bttnSpd) then s1.dy=s1.dy-spd end
 else if keyp(q*-1,bttnSpd,bttnSpd) then s1.dy=s1.dy-spd end
 end
 q=d -- down
 if q <=0 then if btnp(q*-1,bttnSpd,bttnSpd) then s1.dy=s1.dy+spd end
 else if keyp(q*-1,bttnSpd,bttnSpd) then s1.dy=s1.dy+spd end
 end
 q=l -- left
 if q <=0 then if btnp(q*-1,bttnSpd,bttnSpd) then s1.dx=s1.dx-spd end
 else if keyp(q*-1,bttnSpd,bttnSpd) then s1.dx=s1.dx-spd end
 end
 q=r -- right
 if q <=0 then if btnp(q*-1,bttnSpd,bttnSpd) then s1.dx=s1.dx+spd end
 else if keyp(q*-1,bttnSpd,bttnSpd) then s1.dx=s1.dx+spd end
 end
 q=a -- a action1
 if q <=0 then if btnp(q*-1,bttnSpd,bttnSpd) then s1.a1=true end
 else if keyp(q*-1,bttnSpd,bttnSpd) then s1.a1=true end
 end
 q=b -- b action2
 if q <=0 then if btnp(q*-1,bttnSpd,bttnSpd) then s1.a2=true end
 else if keyp(q*-1,bttnSpd,bttnSpd) then s1.a2=true end
 end
 q=x -- x action3
 if q <=0 then if btnp(q*-1,bttnSpd,bttnSpd) then s1.a3=true end
 else if keyp(q*-1,bttnSpd,bttnSpd) then s1.a3=true end
 end
 q=y -- y action4
 if q <=0 then if btnp(q*-1,bttnSpd,bttnSpd) then s1.a4=true end
 else if keyp(q*-1,bttnSpd,bttnSpd) then s1.a4=true end
 end

 if s1.a1 then s1.spd=4 end
 s1.dx = s1.dx * SpeedAdjust(TICK_CNT, s1.spd)
 s1.dy = s1.dy * SpeedAdjust(TICK_CNT, s1.spd)
end