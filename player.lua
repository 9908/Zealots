

function drawPlayer()

   	--DRAW PLAYER

    --love.graphics.rectangle("fill",player.pos.x-player.hitbox_w/2,player.pos.y-player.hitbox_h/2,player.hitbox_w,player.hitbox_h)

	love.graphics.draw(SHADOW_IMG,player.pos.x-1*player.w/5, player.pos.y+2*player.h/5, 0, 3, 3,0,0)

	if player.dead == false then
    if math.sqrt(player.vit.x*player.vit.x+player.vit.y*player.vit.y) < 100 then -- IDLE
		if player.direction == 1 then
			player.anim_idle:draw( player.pos.x-player.w/2, player.pos.y-player.h/2,0, 3*player.direction, 3,0,0)
		else
			player.anim_idle:draw( player.pos.x-2*player.w/2, player.pos.y-player.h/2,0, 3*player.direction, 3,player.w/2,0)
		end
	else -- WALK
		if player.direction == 1 then
			player.anim_walk:draw( player.pos.x-player.w/2, player.pos.y-player.h/2,0, 3*player.direction, 3,0,0)
		else
			player.anim_walk:draw( player.pos.x-2*player.w/2, player.pos.y-player.h/2,0, 3*player.direction, 3,player.w/2,0)
		end
	end
end

	-- love.graphics.setColor(255,0,0)
	-- love.graphics.rectangle("fill",player.pos.x+player.w/2-5, player.pos.y+player.h/2-5, 10,10)
	-- love.graphics.rectangle("fill",player.pos.x+player.w/2-5, player.pos.y-player.h/2-5, 10,10)
	-- love.graphics.rectangle("fill",player.pos.x-player.w/2-5, player.pos.y+player.h/2-5, 10,10)
	-- love.graphics.rectangle("fill",player.pos.x-player.w/2-5, player.pos.y-player.h/2-5, 10,10)
	-- love.graphics.setColor(255,255,255)

	-- DRAW BULLETS

 	for i,v in ipairs(player.bullets) do -- Draw bullets of player
 		v.anim:draw( v.pos.x-v.w/2, v.pos.y-v.h/2,0, 3, 3,0,0)
	end
end

function playerShoot()
	local startX = player.pos.x 
	local startY = player.pos.y 

	if LOSE == false then
		for i = 1,player.weapon.nbr_bullet do
			local mouseX = love.mouse.getX() + CAM_X0
			local mouseY = love.mouse.getY() + CAM_Y0
			local ii = i - player.weapon.nbr_bullet/2
			local angle = math.atan2((mouseY - startY), (mouseX - startX)) + (ii)*math.pi/32

			local bulletDx = 2.5*bulletSpeed * math.cos(angle)
			local bulletDy = 2.5*bulletSpeed * math.sin(angle)

			local shoot_SFX = love.audio.newSource("assets/sounds/shoot.wav", "static")

			pop_pickup_anim(mouseX-12,mouseY-12)

			shoot_SFX:setVolume(0.6)
			shoot_SFX:play()
			table.insert(player.bullets,{ pos = {x = startX, y = startY}, vit = {x = bulletDx, y = bulletDy}, w=7,h=7,anim = BULLET_ANIM})
		end
	end
end

function updatePlayer(dt)

	-- AUTOSHOOT
	if AUTO_SHOOT == true then
		if player.weapon.canShoot then
			player.weapon.canShoot = false
			playerShoot()
			player.weapon.timerAutoShoot = love.timer.getTime()
		end
		if love.timer.getTime() - player.weapon.timerAutoShoot > player.weapon.bullet_reload and player.weapon.canShoot == false then
			player.weapon.canShoot = true
		end
	end

	-- MOUVEMENT

	player.acc.x=0
	player.acc.y=0

	if love.keyboard.isDown('a') then -- left
		player.acc.x=player.acc.x-ACCELERATION
	end
	if love.keyboard.isDown('d') then -- right
		player.acc.x=player.acc.x+ACCELERATION
	end
	if love.keyboard.isDown('w') then -- up
		player.acc.y=player.acc.y-ACCELERATION
	end
	if love.keyboard.isDown('s') then -- down
		player.acc.y=player.acc.y+ACCELERATION
	end

	updateVelocity(player,dt)

	if player.pos.x-player.hitbox_w/2 < 0 then -- limit mvt out of screen left
		player.pos.x = player.hitbox_w/2
		player.vit.x = 0
		player.acc.x = 0
	end
	if player.pos.x+player.hitbox_w/2 > screenWidth+2*CAM_X0 then -- limit mvt out of screen right
		player.pos.x = screenWidth+2*CAM_X0 - player.hitbox_w/2 
		player.vit.x = 0
		player.acc.x = 0
	end
	if player.pos.y-player.hitbox_h/2 < 0 then -- limit mvt out of screen top
		player.pos.y = player.hitbox_h/2
		player.vit.y = 0
		player.acc.y = 0
	end
	if player.pos.y+player.hitbox_h/2 > screenHeight+2*CAM_Y0 then -- limit mvt out of screen bottom
		player.pos.y = screenHeight+2*CAM_Y0 - player.hitbox_h/2
		player.vit.y = 0
		player.acc.y = 0
	end

	-- BULLETS
	for i,v in ipairs(player.bullets) do
		v.pos.x = v.pos.x + (v.vit.x * dt)
		v.pos.y = v.pos.y + (v.vit.y * dt)
		v.anim:update(dt)
		pop_bullet_trail_anim(v.pos.x-v.w/2,v.pos.y-v.h/2)
		for j,w in ipairs(ennemies) do
			if Point_Rectangle_CollisionCheck(v.pos.x,v.pos.y,w.pos.x,w.pos.y,w.w,w.h) then
				if start_new_wave == true then
					Ennemy_hit(w,1,j)
					pop_hit_anim(v.pos.x-11,v.pos.y-11/2,v.vit.x,v.vit.y)
					table.remove(player.bullets,i)
				end

			end
		end
		for j,w in ipairs(crates) do
			if Point_Rectangle_CollisionCheck(v.pos.x,v.pos.y,w.pos.x,w.pos.y,w.w,w.h) then

				pop_hit_anim(v.pos.x-11,v.pos.y-11/2,v.vit.x,v.vit.y)

				table.remove(player.bullets,i)
				w.health = w.health - 1

			end
		end
		if Point_Rectangle_CollisionCheck(v.pos.x,v.pos.y,shrine.hitbox_pos.x,shrine.hitbox_pos.y,shrine.hitbox_w,shrine.hitbox_h) then
				
			pop_hit_anim(v.pos.x-11,v.pos.y-11/2,v.vit.x,v.vit.y)

			table.remove(player.bullets,i)
		end

		if v.pos.x < -50 or v.pos.x > screenWidth+50 or v.pos.y < -50 or v.pos.y > screenHeight+ 50 then -- remove out of screen bullets
			table.remove(player.bullets,i)
		end
	end



	-- ANIM
	player.anim_walk:update(dt)
end