-- title:  color functions
-- author: MonstersGoBoom
-- desc:   findCloseRGB in palette & HSV
-- script: lua


local min = math.min
local max = math.max

function RGBto24()
	local v = (self.r*255)<< 16
	v = v | (self.g*255) << 8
	v = v | (self.b*255)
	return v
end

function RGBfrom24(v)
	local r = ((v>>16)&0xff)/255
	local g = ((v>>8)&0xff)/255
	local b = ((v)&0xff)/255
	return r,g,b
end

function HSVtoRGB(h, s, v)
	local r, g, b
 local i = (h * 6)//1;
 local f = h * 6 - i;
 local p = v * (1 - s);
 local q = v * (1 - f * s);
 local t = v * (1 - (1 - f) * s);
 i = i % 6
 if i == 0 then r, g, b = v, t, p
 elseif i == 1 then r, g, b = q, v, p
 elseif i == 2 then r, g, b = p, v, t
 elseif i == 3 then r, g, b = p, q, v
 elseif i == 4 then r, g, b = t, p, v
 elseif i == 5 then r, g, b = v, p, q
 end
	return r,g,b
end

function RGBtoHSV(r,g,b)
  local max, min = math.max(r, g, b),math.min(r, g, b)
  local h, s, v
  v = max
  local d = max - min
  if max == 0 then s = 0 else s = d / max end
  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end
  return h, s, v
end

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

t=0
x=104
y=24
h = 0
s = 0
v = 0

function findCloseRGB(nr,ng,nb)
	local minDistance = 99999999	
	local value = 0
	for i=0,15 do
		local	dr = peek(0x3fc0+(i*3))
		local dg = peek(0x3fc0+(i*3)+1)
		local db = peek(0x3fc0+(i*3)+2)
		
  local dist = math.sqrt(
        math.pow(nr - dr, 2) +
        math.pow(ng - dg, 2) +
        math.pow(nb - db, 2)
      )
  if (dist <= minDistance) then
    minDistance = dist
    value = i
		end
	end
	return value
end


palette = {}

for p=1,16 do
	palette[p] = {}
	r,g,b = pal(p-1)
	palette[p][1] = r
	palette[p][2] = g
	palette[p][3] = b
end

function TIC()

	if btn(0) then h=h-0.01 end
	if btn(1) then h=h+0.01 end
	if btn(2) then s=s-0.01 end
	if btn(3) then s=s+0.01 end
	if btn(4) then v=v-0.01 end
	if btn(5) then v=v+0.01 end
	h = max(-2.0,h)
	h = min(2.0,h)
	s = max(-2.0,s)
	s = min(2.0,s)
	v = max(-2.0,v)
	v = min(2.0,v)

	cls(0)
	for b=0,15 do 
		for r=0,15 do 
			for g=0,15 do 
				local id = findCloseRGB(r*16,g*16,b*16)
				rect(r+(b*16),g,1,1,id)
			end
		end	
	end

	for y=0,3 do 
		for x=0,3 do 
			local id = y*4 + x
			rect(x*16,16+y*16,16,16,id)
		end	
	end
	
--	spr(1,34,0,-1,4)
	
	

	for p=1,16 do
		r = palette[p][1]/255
		g = palette[p][2]/255
		b = palette[p][3]/255
		_h,_s,_v = RGBtoHSV(r,g,b)
		_h = _h + h
		_s = _s + s
		_v = _v + v
		r,g,b = HSVtoRGB(_h,_s,_v)
		pal(p-1,r*255,g*255,b*255)
	end

	print(string.format("h %.2f s %.2f v%.2f",h,s,v),84,120)
	t=t+1
end
