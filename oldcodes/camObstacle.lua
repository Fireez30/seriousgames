-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

function init()
	p={x=70,
	   y=60,
		vx=0,
		vy=0}
	cam={x=0,
		 y=0}
	solids={[34]=true}
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
	cls()
	map(cam.x//8,cam.y//8,31,18,-(cam.x%8),-(cam.y%8))
	spr(1,p.x,p.y,0,1)
end