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

function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

function init()
	p={x=70,
	   y=60,
		vx=0,
		vy=0,
		a=0,
		health = 100,
		damage = 10}
	cam={x=0,
		 y=0}
	solids={[34]=true}
	ent={
	[0]={x=100,y=30,a=0,speed=0.1,sprite=50,health=10,dead=0}
	}
end
flip=0
function solid(x,y)
	return solids[mget((x)//8,(y)//8)]
end

function playerColl()
		--colisions joueur
	if solid(p.x+p.vx+cam.x,p.y+p.vy+cam.y) or solid(p.x+7+p.vx+cam.x,p.y+p.vy+cam.y) or solid(p.x+p.vx+cam.x,p.y+7+p.vy+cam.y) or solid(p.x+7+p.vx+cam.x,p.y+7+p.vy+cam.y) then
		p.vx=0
	end
	if solid(p.x+cam.x,p.y+8+p.vy+cam.y) or solid(p.x+7+cam.x,p.y+8+p.vy+cam.y) then
		p.vy=0
	end
	if p.vy<0 and (solid(p.x+p.vx+cam.x,p.y+p.vy+cam.y) or solid(p.x+7+p.vx+cam.x,p.y+p.vy+cam.y)) then
  		p.vy=0
 	end
	
end

function updatePlayerandCam()
		--apply player movement and update camera
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
end

function enemyIA(entityNumber)
	if ent[entityNumber].health <= 0 then
		ent[entityNumber].dead = 1
		ent[entityNumber].sprite = 48
	end
	local dist = distance(ent[entityNumber].x,ent[entityNumber].y,p.x + cam.x,p.y + cam.y)
	if dist < 200 and ent[entityNumber].dead == 0 then
		ent[entityNumber].a = angle2(ent[entityNumber].x,ent[entityNumber].y,p.x+cam.x,p.y+cam.y)
 		-- print the dot at 10 pixel of distance
		local angle = ent[entityNumber].a
		-- the displacement is simply speed oriented at our angle
		local dipx,dipy = rotate(0, -ent[entityNumber].speed,angle)
		-- now just add displacement to our position

		--colisions entité test
		if solid(ent[entityNumber].x+dipx,ent[entityNumber].y+dipy) or solid(ent[entityNumber].x+7+dipx,ent[entityNumber].y+dipy) or solid(ent[entityNumber].x+dipx,ent[entityNumber].y+7+dipy) or solid(ent[entityNumber].x+7+dipx,ent[entityNumber].y+7+dipy) then
			dipx=0
		end
		if solid(ent[entityNumber].x,ent[entityNumber].y+8+dipy) or solid(ent[entityNumber].x+7,ent[entityNumber].y+8+dipy) then
			dipy=0
		end
		if dipy<0 and (solid(ent[entityNumber].x+dipx,ent[entityNumber].y+dipy) or solid(ent[entityNumber].x+7+dipx,ent[entityNumber].y+dipy)) then
  			dipy=0
 		end

		ent[entityNumber].x = ent[entityNumber].x + dipx
		ent[entityNumber].y = ent[entityNumber].y + dipy

		spr(ent[entityNumber].sprite,ent[entityNumber].x - cam.x,ent[entityNumber].y - cam.y,0,1)
		ent[entityNumber].a = 0
	end
end

init()
function TIC()
	--reset next movement
	p.vx = 0
	p.vy=0

	--input
	if btn(2) then
		p.vx=-1
		flip=1
	elseif btn(3) then
		p.vx=1
		flip=0
	end
	if btn(0) then
		p.vy=-1
	elseif btn(1) then
		p.vy=1
	end
	
	playerColl()
	updatePlayerandCam()


	cls()
	map(cam.x//8,cam.y//8,31,18,-(cam.x%8),-(cam.y%8))

	for k,v in pairs(ent) do
		enemyIA(k)
	end

	local opp = null
	print("" .. (p.x+p.vx+cam.x) .. " / " .. (p.y+p.vy+cam.y), 5, 5)
	if mget(p.x+p.vx+cam.x,p.y+p.vy+cam.y) > 48 then 
		local opp = mget(p.x+p.vx+cam.x,p.y+p.vy+cam.y)
		print("Pas d'ajout",10,10)
	elseif mget(p.x+7+p.vx+cam.x,p.y+p.vy+cam.y) > 48 then
		opp = mget(p.x+7+p.vx+cam.x,p.y+p.vy+cam.y)
		print("x + 7",10,10)
	elseif mget(p.x+p.vx+cam.x,p.y+7+p.vy+cam.y) > 48 then
		opp = mget(p.x+p.vx+cam.x,p.y+7+p.vy+cam.y)
		print("x + 7",10,10)
	elseif mget(p.x+7+p.vx+cam.x,p.y+7+p.vy+cam.y)> 48 then
		opp = mget(p.x+7+p.vx+cam.x,p.y+7+p.vy+cam.y)
		print("x + 7 y + 7",10,10)
	end

	local i = 0
	local toDamage = {}
	for k,v in pairs(ent) do
		if ent[k] == opp then
			if distance(ent[k].x,ent[k].y,p.x + cam.x,p.y + cam.y) < 8 then
				toDamage[i] = k
				i = i + 1
			end
		end
	end

	if btn(4) then
		print(opp,p.x,p.y-10)

		for k,v in pairs(toDamage) do
			ent[toDamage[k]].health = ent[toDamage[k]].health - p.damage
		end
	end
	
	spr(1,p.x,p.y,-1,1,flip,0,1,1)
end