
function solid(x,y)
	return solids[mget((x)//8,(y)//8)]
end

function init()
	solids={[49]=true,[50]=true}
	p={
		x=120,
		y=68,
		vx=0,
		vy=0,
	}
	t=0
	flip=0
end

init()

function TIC()

	if btn(2) then 
			p.vx=-1
			flip=1
		elseif btn(3) then 
			p.vx=1
			flip=0
		else 
			p.vx=0
	end

	if solid(p.x+p.vx,p.y+p.vy) or solid(p.x+7+p.vx,p.y+p.vx) or solid(p.x+p.vx,p.y+15+p.vy) or solid(p.x+7+p.vx,p.y+15+p.vy) then
		p.vx=0
	end	

	if solid(p.x,p.y+16+p.vy) or solid(p.x+7,p.y+16+p.vy) then
			p.vy=0
		else
			p.vy=p.vy+0.2
	end
	
	if p.vy==0 and btnp(4) then
		p.vy = -2.5
	end
	
	if p.vy<0 and (solid(p.x+p.vx,p.y+p.vy) or solid(p.x+7+p.vx,p.y+p.vy)) then
  p.vy=0
 end
	
	p.x=p.x+p.vx
	p.y=p.y+p.vy
	
	cls()
	map()
	spr(1+t%60//30,p.x,p.y,0,1,flip,0,1,2)
	print("HELLO WORLD!",84,84)
	t=t+1
end
