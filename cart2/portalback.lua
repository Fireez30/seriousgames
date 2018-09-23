	if orangeportal.display == 1 then
		mset(orangeportal.x//8,orangeportal.y//8,18)
	end
	if blueportal.display == 1 then
		mset(blueportal.x//8,blueportal.y//8,17)
	end


	--------------------------------


	function portalTP()
	if p.x+cam.x == blueportal.x and p.y+cam.y == blueportal.y then
		p.x = orangeportal.x
		p.y = orangeportal.y	
	elseif p.x == orangeportal.x and p.y == orangeportal.y then
 	p.x = blueportal.x
		p.y = blueportal.y
	end
end

--------------------------------------

	blueportal={
	x=30,
	y=90,
	display=1
	}
	orangeportal={
	x=50,
	y=90,
	display=1
	}