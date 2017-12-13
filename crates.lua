HEALTH_MAX = 20

function drawCrates()
	 for i,v in ipairs(crates) do  -- Draw ceates
    	--love.graphics.rectangle("fill",v.pos.x-v.w/2,v.pos.y-v.h/2,v.w,v.h)
 		love.graphics.draw(BOX_SHADOW_IMG,v.pos.x-27,v.pos.y-30, 0, 3, 3, 0,0)
    	if v.health >= HEALTH_MAX then
 			love.graphics.draw(v.img,v.pos.x-v.w/2,v.pos.y-v.h/2, 0, 3, 3, 0,0)
 		elseif v.health >= 8 then
 			love.graphics.draw(v.img_d1,v.pos.x-v.w/2,v.pos.y-v.h/2, 0, 3, 3, 0,0)
		elseif v.health >= 6 then
 			love.graphics.draw(v.img_d2,v.pos.x-v.w/2,v.pos.y-v.h/2, 0, 3, 3, 0,0)
		elseif v.health >= 4 then
 			love.graphics.draw(v.img_d3,v.pos.x-v.w/2,v.pos.y-v.h/2, 0, 3, 3, 0,0)
		else 
 			love.graphics.draw(v.img_d4,v.pos.x-v.w/2,v.pos.y-v.h/2, 0, 3, 3, 0,0)
 		end
	end
end

function updateCrates(dt)
	 for i,v in ipairs(crates) do  -- Draw ceates
    	if v.health <= 0 then
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

function checkOccupiedSpot(index_i, index_j)
	occupied_spot = false

	for i,v in ipairs(crates) do  -- check if there is already a crate there
    	if v.i == index_i and v.j == index_j then
    		occupied_spot = true
    	end
	end
	for i,v in ipairs(items) do  -- check if there is already a crate there
    	if v.i == index_i and v.j == index_j then
    		occupied_spot = true
    	end
	end

	return occupied_spot
end

function newBox( x,y )

	if x > 0 and y > 0 and x < screenWidth +2*CAM_X0 and y < screenHeight + 2*CAM_Y0 then
	local index_i = math.floor(x/TILE_W)+1
	local index_j = math.floor(y/TILE_H)+1



	if checkOccupiedSpot(index_i, index_j) == false then
		player.crates_nbr = player.crates_nbr -1
		local posx = index_i*TILE_W-TILE_W/2
		local posy = index_j*TILE_H-TILE_H/2
		table.insert(crates, {
			i=index_i,
			j=index_j,
			img=BOX_IMG,
			img_d1 = BOX_D1_IMG,
			img_d2 = BOX_D2_IMG,
			img_d3 = BOX_D3_IMG,
			img_d4 = BOX_D4_IMG,
			w=3*BOX_IMG:getWidth(),
			h=3*BOX_IMG:getHeight(),
			pos={x=posx,y=posy},
			health = HEALTH_MAX}
		)

		pop_crate_anim(posx,posy)
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
end
