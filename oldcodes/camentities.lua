-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua


function rotate(x,y,a)
 return 
  x*math.cos(a)-y*math.sin(a),
  x*math.sin(a)+y*math.cos(a)
end

function angleAdd(a, d)
 a=a+d
 -- ensure angle is in 0..2pi range
 if a<0 then 
   a=a+pi2
 elseif a>=pi2 then 
   a=a-pi2
 end
 return a
end

function angle(x,y)
 return math.pi - math.atan2(x,y) -- correct!
end

function vector(length, angle)
 return rotate(0, -length, angle)
end

-- give the angle from a certain point
-- to another point
function angle2(fromx,fromy, tox, toy)
 return angle(tox-fromx, toy-fromy)
end

function angleDir(from, to)
 local diff = to-from
 if math.abs(diff) < 0.00001 then return 0 end -- avoid rounding errors that will prevent settling
 if diff > math.pi then 
   return -1 
 elseif diff < -math.pi then
   return 1 
 else 
   return diff>0 and 1 or -1
 end
end

function init()
	p={x=70,
	   y=60,
		vx=0,
		vy=0,
		a=0}
	cam={x=0,
		 y=0}
	solids={[34]=true}
	ent={
	[50]={x=160,y=112,a=0}
	}
end

function solid(x,y)
	return solids[mget((x)//8,(y)//8)]
end

init()
function TIC()
p.vx = 0
p.vy=0
	if btn(2) then
		p.vx=-1
	elseif btn(3) then
		p.vx=1
	end
	if btn(0) then
		p.vy=-1
	elseif btn(1) then
		p.vy=1
	end

	
	if solid(p.x+p.vx+cam.x,p.y+p.vy+cam.y) or solid(p.x+7+p.vx+cam.x,p.y+p.vy+cam.y) or solid(p.x+p.vx+cam.x,p.y+7+p.vy+cam.y) or solid(p.x+7+p.vx+cam.x,p.y+7+p.vy+cam.y) then
		p.vx=0
	end
	if solid(p.x+cam.x,p.y+8+p.vy+cam.y) or solid(p.x+7+cam.x,p.y+8+p.vy+cam.y) then
		p.vy=0
	end
	if p.vy<0 and (solid(p.x+p.vx+cam.x,p.y+p.vy+cam.y) or solid(p.x+7+p.vx+cam.x,p.y+p.vy+cam.y)) then
  		p.vy=0
 	end
	
	if p.vx==1 and p.x < 150 then
		p.x = p.x + p.vx
	elseif p.vx==1 and p.x >=150 then
		cam.x = cam.x + p.vx
	end
	if p.vx==-1 and p.x >90 then
		p.x = p.x + p.vx
	elseif p.vx==-1 and p.x <=90 then
		cam.x = cam.x + p.vx
	end
	if p.vy==1 and p.y < 78 then
		p.y = p.y + p.vy
	elseif p.vy==1 and p.y >= 78 then
		cam.y = cam.y + p.vy
	end
	if p.vy==-1 and p.y > 50 then
		p.y = p.y + p.vy
	elseif p.vy==-1 and p.y <= 50 then
		cam.y = cam.y + p.vy
	end
	
	ent[50].a = angle2(ent[50].x,ent[50].y,p.x,p.y)
 -- print the dot at 10 pixel of distance
	local speed=0.1
	local angle = ent[50].a
-- the displacement is simply speed oriented at our angle
local dipx,dipy = rotate(0, -speed,angle)
-- now just add displacement to our position
ent[50].x = ent[50].x + dipx
ent[50].y = ent[50].y + dipy

	cls()
	map(cam.x//8,cam.y//8,31,18,-(cam.x%8),-(cam.y%8))
	spr(1,p.x,p.y,0,1)
	spr(50,ent[50].x,ent[50].y,0,1)
	ent[50].a = 0
end