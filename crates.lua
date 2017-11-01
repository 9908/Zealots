HEALTH_MAX = 5

function drawCrates()
	 for i,v in ipairs(crates) do  -- Draw ceates
    	--love.graphics.rectangle("fill",v.pos.x-v.w/2,v.pos.y-v.h/2,v.w,v.h)
 		love.graphics.draw(BOX_SHADOW_IMG,v.pos.x-27,v.pos.y-30, 0, 3, 3, 0,0)
    	if v.health == HEALTH_MAX then
 			love.graphics.draw(v.img,v.pos.x-v.w/2,v.pos.y-v.h/2, 0, 3, 3, 0,0)
 		else
 			love.graphics.draw(v.img_damaged,v.pos.x-v.w/2,v.pos.y-v.h/2, 0, 3, 3, 0,0)
 		end
	end
end

function updateCrates(dt)
	 for i,v in ipairs(crates) do  -- Draw ceates
    	if v.health < 0 then
    		local index_i = v.i
    		local index_j = v.j
    		table.remove(crates,i)

    		-- update map
			handler:updateMap(index_i,index_j,0)

			-- update paths of ennemies
			for ii,vv in ipairs(ennemies) do  -- check if there is already a crate there	
				if vv.IA == 1 then
    				vv.path = computePathtoGoal(vv.pos,shrine)
    			else 
    				vv.path = computePathtoGoal(vv.pos,player)  
    			end
			end

    	end
	end
end

function newBox( x,y )

	local index_i = math.floor(x/TILE_W)+1
	local index_j = math.floor(y/TILE_H)+1

	local occupied_spot = false

	for i,v in ipairs(crates) do  -- check if there is already a crate there	
    	if v.i == index_i and v.j == index_j then
    		occupied_spot = true
    	end
	end

	if occupied_spot == false then
		player.crates_nbr = player.crates_nbr -1
		local posx = index_i*TILE_W-TILE_W/2
		local posy = index_j*TILE_H-TILE_H/2
		table.insert(crates, {
			i=index_i,
			j=index_j,
			img=BOX_IMG,
			img_damaged = BOX_DAMAGED_IMG,
			w=3*BOX_IMG:getWidth(),
			h=3*BOX_IMG:getHeight(),
			pos={x=posx,y=posy},
			health = 5}
		)
		
		animImg = newAnimation(love.graphics.newImage("assets/box-pop.png"), 23,23, 0.05, 0)
		animImg:setMode("once")
		table.insert(anims,{ x = posx-34, y = posy-36 , animation = animImg, scaleX =3, scaleY = 3,loop=false,angle=0})
		
		-- update map
		handler:updateMap(index_i,index_j,1)

		-- update paths of ennemies
		for i,v in ipairs(ennemies) do  -- check if there is already a crate there	
			if v.IA == 1 then
    			v.path = computePathtoGoal(v.pos,shrine)
    		else 
    			v.path = computePathtoGoal(v.pos,player)  
    		end
		end

		local box_pose_SFX = love.audio.newSource("assets/sounds/box_pose.wav", "static")
		box_pose_SFX:setVolume(0.5)
		box_pose_SFX:play()
	end

end