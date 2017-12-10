function drawItems()
	 for i,v in ipairs(items) do  -- Draw ceates
    	--love.graphics.rectangle("fill",v.pos.x-v.w/2,v.pos.y-v.h/2,v.w,v.h)

 		--love.graphics.draw(ITEM_SHADOW_IMG,v.pos.x-v.w/2+4,v.pos.y-4, 0, 3, 3, 0,0)
 		v.anim:draw( v.pos.x-v.w/2,v.pos.y-v.h/2, 0, 3, 3, 0,0)
	end
end

function updateItems(dt)
	for i,v in ipairs(items) do  -- pick up item
    	if distance(v.pos.x,v.pos.y,player.pos.x,player.pos.y) < 70 then
    		if v.item_type == 1 then -- Pick up crate
    			player.crates_nbr = player.crates_nbr + 8
				addCrateMessage("+8")
    		else
				--useCustomFont(50)
    			if v.item_type == 2 then -- LASER frequence
    				player.weapon.bullet_reload = player.weapon.bullet_reload - 0.025
					addAttackMessage("Reload faster!")
    			elseif v.item_type == 3 then -- MINIGUN frequence
    				player.weapon.bullet_reload = player.weapon.bullet_reload - 0.025
					addAttackMessage("Reload faster!")
    			elseif v.item_type == 4 then -- ROCKET zone impact
    				player.weapon.nbr_bullet = player.weapon.nbr_bullet+1
					addAttackMessage("Spread shoot!")
    			elseif v.item_type == 5 then -- SHOTGUN nombre de balle tire en un angle
    				player.weapon.nbr_bullet = player.weapon.nbr_bullet+1
					addAttackMessage("Spread shoot!")
    			elseif v.item_type == 6 then -- SHIELD
    				player.stack = player.stack+1
					addShieldMessage("+1")
    			end
    		end
    		pop_pickup_anim(v.pos.x-15,v.pos.y-15)
    		pickup_item_SFX:play()

    		table.remove(items,i)
    	end

    	v.anim:update(dt)
	end
end

function newCrateSupply()
	-- body
	local local_x = 1
	local local_y = 1

	local location = getRandomLocation()
	local_x = location.x
	local_y = location.y

	ITEM_ANIM = newAnimation(ITEM_ANIM_IMG, 16, 24, 0.2, 0)
	ITEM_ANIM:setMode("loop")

	table.insert(items, {
		item_type = 1,
		anim=ITEM_ANIM,
		w=3*16,
		h=3*20,
		pos={x=local_x, y=local_y}}
	)
end

function getRandomLocation()
	local location = {}
	local randomX = -CAM_X0 + math.random(screenWidth+2*CAM_X0)
	local randomY = -CAM_Y0 + math.random(screenHeight+2*CAM_Y0)
	local index_i = math.floor(randomX/TILE_W)+1
	local index_j = math.floor(randomY/TILE_H)+1

	location = {x=randomX,y=randomY}
	while checkOccupiedSpot(index_i, index_j)  do
		location = {x=randomX,y=randomY}

		randomX = -CAM_X0 + math.random(screenWidth+2*CAM_X0)
		randomY = -CAM_Y0 + math.random(screenHeight+2*CAM_Y0)

		if randomX >= screenWidth then -- trop à droite
			randomX = screenWidth+CAM_X0
		elseif randomX < CAM_X0 then -- trop à gauche
			randomX = CAM_X0
		end
		if randomY >= screenHeight then -- trop bas
			randomY = screenHeight+CAM_Y0
		elseif randomY < CAM_Y0 then
			randomY = CAM_Y0
		end

		index_i = math.floor(randomX/TILE_W)+1
		index_j = math.floor(randomY/TILE_H)+1
	end

	return location
end

function newPowerUp()
	-- body
	local rdm = math.random(5) -- Roll powerup
	local local_x = 1
	local local_y = 1

	local location = getRandomLocation()
	local_x = location.x
	local_y = location.y

	local item_type = 1
	if rdm == 1 then -- LASER
		ITEM_ANIM = newAnimation(POWERUP1_ANIM_IMG, 16, 22, 0.2, 0)
		ITEM_ANIM:setMode("loop")
		item_type = 2
	elseif rdm == 2 then  -- MINIGUN
		ITEM_ANIM = newAnimation(POWERUP2_ANIM_IMG, 16, 22, 0.2, 0)
		ITEM_ANIM:setMode("loop")
		item_type = 3
	elseif rdm == 3 then -- ROCKET
		ITEM_ANIM = newAnimation(POWERUP3_ANIM_IMG, 16, 22, 0.2, 0)
		ITEM_ANIM:setMode("loop")
		item_type = 4
	elseif rdm == 4 then -- SHOTGUN
		ITEM_ANIM = newAnimation(POWERUP4_ANIM_IMG, 16, 22, 0.2, 0)
		ITEM_ANIM:setMode("loop")
		item_type = 5
	elseif rdm == 5 then -- SHIEDL
		ITEM_ANIM = newAnimation(POWERUP5_ANIM_IMG, 16, 24, 0.2, 0)
		ITEM_ANIM:setMode("loop")
		item_type = 6
	end


	table.insert(items, {
		item_type = item_type,
		anim=ITEM_ANIM,
		w=3*16,
		h=3*24,
		pos={x=local_x, y=local_y}}
	)
end
