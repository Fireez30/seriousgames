-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

function init()
	p={x=70,
	   y=60,
		vx=0,
		vy=0,
		a=0,
		health = 100,
		damage = 10,
		flip=0,
		world=0}
	solids={[33]=true,[34]=true,[35]=true}
	ent={
	--[0]={x=100,y=30,a=0,speed=0.1,sprite=50,health=10,dead=0}
	}
	PLAYER_RESPAWN_POINT={x=75,y=65}
	level = 0
	PAUSE = 0
end

function respawnPlayer()
    --if body is the player then...
   p.x=PLAYER_RESPAWN_POINT.x
   p.y=PLAYER_RESPAWN_POINT.y
   p.vx = 0
   p.vy = 0
end

-- swap c0 and c1 colors, call pal() to reset
function pal(i,r,g,b)
	--sanity checks
	if i<0 then i=0 end
	if i>15 then i=15 end
	--returning color r,g,b of the color
	if r==nil and g==nil and b==nil then
		return peek(0x3fc0+(i*3)),peek(0x3fc0+(i*3)+1),peek(0x3fc0+(i*3)+2)
	else
		if r==nil or r<0 then r=0 end
		if g==nil or g<0 then g=0 end
		if b==nil or b<0 then b=0 end
		if r>255 then r=255 end
		if g>255 then g=255 end
		if b>255 then b=255 end
		poke(0x3fc0+(i*3)+2,b)
		poke(0x3fc0+(i*3)+1,g)
		poke(0x3fc0+(i*3),r)
	end
end


function switchWorld()
	if p.world < 3 then
		p.world = p.world + 1
		--p.x = p.x
		--p.y = p.y + (17*8-1)
	else
		p.world = 0
		--p.x = p.x
		--p.y = p.y - 3*(17*8)-1
	end
end

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

function solid(x,y)
	return mget(x//8+level,(y)//8+p.world*17) > 79
end

function endCheck()
	local id = mget(p.x//8+level,p.y//8+p.world*17)
	if id == 39 then
		mset(57,02,32)
		mset(p.x//8+level,p.y//8+p.world*17,49)
	end
	if id == 34 or id == 35 or id == 36 or id == 37 then
	print("Death!",p.x+level,p.y+p.world*17) 
		PLAYER_RESPAWN_POINT.x = PLAYER_RESPAWN_POINT.x
		PLAYER_RESPAWN_POINT.y = PLAYER_RESPAWN_POINT.y
		level = level + 31
		respawnPlayer()
	--	PAUSE = 1

	end
end
function playerCollTopDown()
		--colisions joueur
	if solid(p.x+p.vx,p.y+p.vy) or solid(p.x+7+p.vx,p.y+p.vy) or solid(p.x+p.vx,p.y+7+p.vy) or solid(p.x+7+p.vx,p.y+7+p.vy) then
		p.vx=0
	end
	if solid(p.x,p.y+8+p.vy) or solid(p.x+7,p.y+8+p.vy) then
		p.vy=0
	end
	if p.vy<0 and (solid(p.x+p.vx,p.y+p.vy) or solid(p.x+7+p.vx,p.y+p.vy)) then
  		p.vy=0
 	end
	
end

function deathCheck()
	if solid(p.x,p.y) then
		p.health = 0
	end

	if p.health == 0 then
		respawnPlayer()
		p.health = 100
	end

	if p.y > 100*8 then
		respawnPlayer()
	end
end

function playerCollPlatformer()
		--colisions joueur
	if solid(p.x+p.vx,p.y+p.vy) or solid(p.x+7+p.vx,p.y+p.vy) or solid(p.x+p.vx,p.y+7+p.vy) or solid(p.x+7+p.vx,p.y+7+p.vy) then
		p.vx=0
	end

	if solid(p.x,p.y+p.vy) or solid(p.x+7,p.y+p.vy) then
		p.vy=0
	end

	if solid(p.x,p.y+8+p.vy) or solid(p.x+7,p.y+8+p.vy) then
			p.vy=0
		else
			p.vy=p.vy+0.2
	end
	
end

function updatePlayerandCam()
		--apply player movement and update camera
--	if p.vx==1 and p.x < 150 then
--		p.x = p.x + p.vx
--	elseif p.vx==1 and p.x >=150 then
--		cam.x = cam.x + p.vx
--	end
--	if p.vx==-1 and p.x >90 then
--		p.x = p.x + p.vx
--	elseif p.vx==-1 and p.x <=90 then
--		cam.x = cam.x + p.vx
--	end
--	if p.vy>0 and p.y < 78 then
--		p.y = p.y + p.vy
--	elseif p.vy>0 and p.y >= 78 then
--		cam.y = cam.y + p.vy
--	end
--	if p.vy<0 and p.y > 50 then
--		p.y = p.y + p.vy
--	elseif p.vy<0 and p.y <= 50 then
--		cam.y = cam.y + p.vy
--	end
p.x = p.x + p.vx
p.y = p.y + p.vy
end


function enemyIA(entityNumber)
	if ent[entityNumber].health <= 0 then
		ent[entityNumber].dead = 1
		ent[entityNumber].sprite = 48
	end
	local dist = distance(ent[entityNumber].x,ent[entityNumber].y,p.x,p.y)
	if dist < 200 and ent[entityNumber].dead == 0 then
		ent[entityNumber].a = angle2(ent[entityNumber].x,ent[entityNumber].y,p.x,p.y)
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

 		if solid(ent[entityNumber].x,ent[entityNumber].y+8+dipy) or solid(ent[entityNumber].x+7,ent[entityNumber].y+8+dipy) then
			dipy=0
		else
			dipy=dipy+0.2
		end

		ent[entityNumber].x = ent[entityNumber].x + dipx
		ent[entityNumber].y = ent[entityNumber].y + dipy

		spr(ent[entityNumber].sprite,ent[entityNumber].x,ent[entityNumber].y,0,1)
		ent[entityNumber].a = 0
	end
end


function inputMovement()
	if btn(2) then
		p.vx=-1
		p.flip=1
	elseif btn(3) then
		p.vx=1
		p.flip=0
	else
		p.vx = 0
	end
-- if btn(0) then
--		p.vy=-1
--	elseif btn(1) then
--		p.vy=1
--	end
	if p.vy==0 and btnp(4) then
		p.vy = -3.2
	end


end
init()
function TIC()
if PAUSE == 0 then
	if btnp(5) then
		switchWorld()
	end
		
	inputMovement()
--	playerCollTopDown()
	playerCollPlatformer()
	updatePlayerandCam()
	deathCheck()
	endCheck()
	
	

	
	for k,v in pairs(ent) do
		enemyIA(k)
	end

	print("" .. (p.x+p.vx) .. " / " .. (p.y+p.vy), 5, 5)
	

	local i = 0
	local toDamage = {}
	for k,v in pairs(ent) do
		if ent[k] == opp then
			if distance(ent[k].x,ent[k].y,p.x,p.y) < 8 then
				toDamage[i] = k
				i = i + 1
			end
		end
	end

	if btn(4) then
		for k,v in pairs(toDamage) do
			ent[toDamage[k]].health = ent[toDamage[k]].health - p.damage
		end
	end
	

	cls()
	map(level,p.world*17)
	spr(1,p.x,p.y,0,1,p.flip,0,1,1)
	print("Se deplacer : fleches", 5, 5)
	print("Sauter : Z", 5, 15)
	print("Changer de saison : X", 5, 25)
-- if p.flip == 0 then
--		spr(16,p.x+7,p.y,0,1,p.flip,0,1,1)
--	else
--		spr(16,p.x-7,p.y,0,1,p.flip,0,1,1)
--	end
else
		map(8)
		print("Felicitations !", 120,68)
end
end