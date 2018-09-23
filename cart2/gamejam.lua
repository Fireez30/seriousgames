5 jours pour faire un jeu seul 
-> tic 80 oblige
-> "portals"
 refaire mécanique de portal 

-- swap c0 and c1 colors, call pal() to reset
function pal(c0,c1)
	if(c0==nil and c1==nil)then for i=0,15 do poke4(0x3FF0*2+i,i)end
	else poke4(0x3FF0*2+c0,c1)end
end


Theme : 4 Saisons
-> chaque monde x 4, on se déplace de l'un a l'autre 
-> intervenir dans chaque mon pour clear un niveau 
-> si un joueur est dans un bloc il meurt, faire réfléchir le joueur a ou réaparaitre 