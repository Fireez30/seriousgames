-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

function init()
	t=0
	p={x=120,
				y=64}
	cam={x=0,
						y=0}
	offsetX=8
	offsetY=0
end

init()

function TIC()
	if btn(2) then
			if p.x > 90 then
					p.x=p.x-1
				else
					cam.x=cam.x-1
					offsetX=8-cam.x%8
			end
		elseif btn(3) then
			if p.x < 150 then
					p.x=p.x+1
				else
					cam.x=cam.x+1
					offsetX=8-cam.x%8
			end
	end
	if btn(0) then
			if p.y > 50 then
					p.y=p.y-1
				else
					cam.y=cam.y-1
			end
		elseif btn(1) then
			if p.y < 78 then
					p.y=p.y+1
				else
					cam.y=cam.y+1
			end
	end
	if t%30==0 then
		--offsetX = offsetX-1
		if offsetX < 0 then
			--cam.x = cam.x+8
			--offsetX = 7
		end
	end
	cls()
	map(cam.x//8-1,cam.y//8,31,17,offsetX,0)
	spr(1,p.x,p.y,0,2)
	t=t+1
end


