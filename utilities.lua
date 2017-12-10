
AUTO_SHOOT = false
----- Input
function love.mousepressed(loc_x, loc_y, button)
	if GAME_STATE == 'PLAY' then
		if button == 1 then -- shoot

			AUTO_SHOOT = true

			-- local startX = player.pos.x
			-- local startY = player.pos.y
			-- local mouseX = loc_x + CAM_X0
			-- local mouseY = loc_y + CAM_Y0

			-- local angle = math.atan2((mouseY - startY), (mouseX - startX))

			-- local bulletDx = 2.5*bulletSpeed * math.cos(angle)
			-- local bulletDy = 2.5*bulletSpeed * math.sin(angle)

			-- local shoot_SFX = love.audio.newSource("assets/sounds/shoot.wav", "static")

			-- pop_pickup_anim(mouseX-12,mouseY-12)

			-- shoot_SFX:setVolume(0.6)
			-- shoot_SFX:play()
			-- table.insert(player.bullets,{ pos = {x = startX, y = startY}, vit = {x = bulletDx, y = bulletDy}, w=7,h=7,anim = BULLET_ANIM})
			playerShoot()
		elseif button == 2 then -- place crate
	 		SHOW_GRID = true
		end

	end
end


function love.mousereleased(loc_x, loc_y, button)
	if button == 1 then
		AUTO_SHOOT = false
	elseif button == 2 then
	 	SHOW_GRID = false
		local mouseX = loc_x + CAM_X0
		local mouseY = loc_y + CAM_Y0
		if player.crates_nbr > 0 then
			newBox(mouseX,mouseY)
		end
	end
end
function love.keypressed (key)

   if key == 'escape' then
		love.event.quit()
   -- elseif key == "left" then
   -- 		applyforceX(player,-100)
   -- elseif key == "right" then
   -- 		applyforceX(player,100)
   -- elseif key == "up" then
   -- 		applyforceY(player,-100)
   -- elseif key == "down" then
   -- 		applyforceY(player,100)
   end
   if key == 'space' then
   		if (GAME_STATE == "START_MENU" or GAME_STATE == "LOSE") then
   			restartGame()
   		end
	end
	if debug then
		if key == 'b' then
			GAME_STATE = "LOSE"
		end
		if key == 'e' then
			newPowerUp()
		end
	end

end

-- MOVEMENT PHYSICS

function updateVelocity(v,dt)
	if v.vit.x > 0 then
		v.direction = 1
	else
		v.direction = -1
	end

	v.vit.x=v.vit.x+v.acc.x*dt
	v.vit.y=v.vit.y+v.acc.y*dt

	local distX = v.vit.x*dt
	local distY = v.vit.y*dt

	local nextX = v.pos.x + distX
	local nextY = v.pos.y + distY

	if not(v.vit.x == 0) then
		 v.pos.x =  v.pos.x + stepX(v,nextX)
	end
	if not(v.vit.y == 0) then
		v.pos.y =  v.pos.y + stepY(v,nextY)
	end


	-- friction decceleration
	v.vit.x=v.vit.x*math.pow(friction_mu,dt)
	v.vit.y=v.vit.y*math.pow(friction_mu,dt)

	-- DUST ANIM
		-- TIMERS

	if love.timer.getTime() - v.timerStartDust > v.DELAY_POP_DUST and v.popdust == false then

		v.popdust = true
	end

	if v.popdust == true then
		if math.sqrt(v.vit.x * v.vit.x + v.vit.y * v.vit.y) > 10 then
			pop_dust_anim(v.pos.x,v.pos.y+v.h/2,v.direction)
		end
		v.popdust = false
		v.timerStartDust = love.timer.getTime()
	end



end

function checkXcollisions( v,x_col )
	-- returns array of tiles intersecting {x = , y = }
	local tiles = {} 	 -- array of tiles
	local ychecking_pos = {v.pos.y-v.hitbox_h/2+1, v.pos.y+v.hitbox_h/2-1}

	for i,w in pairs(crates) do
		for j = 1,2,1 do -- check for all ychecking_pos (here size = 2)
			if Point_Rectangle_CollisionCheck(x_col,ychecking_pos[j],w.pos.x,w.pos.y,w.w,w.h) then
				table.insert(tiles,w)
			end
		end
	end

	for j = 1,2,1 do -- check for all ychecking_pos (here size = 2)
		if Point_Rectangle_CollisionCheck(x_col,ychecking_pos[j],shrine.hitbox_pos.x,shrine.hitbox_pos.y,shrine.hitbox_w,shrine.hitbox_h) then
		table.insert(tiles, {
			i=1,
			j=1,
			img=nil,
			w=shrine.hitbox_w,
			h=shrine.hitbox_h,
			pos={x=shrine.hitbox_pos.x,y=shrine.hitbox_pos.y}}
		)
		end
	end
	return tiles
end

function checkYcollisions( v,y_col )
	-- returns array of tiles intersecting {x = , y = }
	local tiles = {} 	 -- array of tiles
	local xchecking_pos = {v.pos.x-v.hitbox_w/2+1, v.pos.x+v.hitbox_w/2-1}

	for i,w in pairs(crates) do
		for j = 1,2,1 do -- check for all xchecking_pos (here size = 2)
			if Point_Rectangle_CollisionCheck(xchecking_pos[j],y_col,w.pos.x,w.pos.y,w.w,w.h) then
				table.insert(tiles,w)
			end
		end
	end
	for j = 1,2,1 do -- check for all ychecking_pos (here size = 2)
		if Point_Rectangle_CollisionCheck(xchecking_pos[j],y_col,shrine.hitbox_pos.x,shrine.hitbox_pos.y,shrine.hitbox_w,shrine.hitbox_h) then
		table.insert(tiles, {
			i=1,
			j=1,
			img=nil,
			w=shrine.hitbox_w,
			h=shrine.hitbox_h,
			pos={x=shrine.hitbox_pos.x,y=shrine.hitbox_pos.y}}
		)
		end
	end
	return tiles

end

function stepX(v,nextX )
	local x_col -- coordinate of the forward-facing edge
	if v.vit.x > 0 then -- facing right
		x_col = nextX + v.hitbox_w/2
	elseif v.vit.x < 0 then  -- facing left
		x_col = nextX - v.hitbox_w/2
	end

	local intersecting_tiles = checkXcollisions(v,x_col)
	-- Check which obstacle is the closest (in this case they are all at the same distance)
	local distX = nextX - v.pos.x

	for i, tile in ipairs(intersecting_tiles) do

			if v.vit.x > 0  then -- facing right
				distX = tile.pos.x-tile.w/2 - (v.pos.x + v.hitbox_w/2)
			elseif v.vit.x < 0 then  -- facing left
				distX = tile.pos.x+tile.w/2 - (v.pos.x - v.hitbox_w/2)
			end

	end
	return distX
end

function stepY(v,nextY )
	local y_col -- coordinate of the forward-facing edge
	if v.vit.y > 0 then -- facing down
		y_col = nextY + v.hitbox_h/2
	elseif v.vit.y < 0 then  -- facing up
		y_col = nextY - v.hitbox_h/2
	end

	local intersecting_tiles = checkYcollisions(v,y_col)
	-- Check which obstacle is the closest (in this case they are all at the same distance)
	local distY = nextY - v.pos.y

	for i, tile in ipairs(intersecting_tiles) do

			if v.vit.y > 0  then -- facing down
				distY = tile.pos.y-tile.h/2 - (v.pos.y + v.hitbox_h/2)
			elseif v.vit.y < 0 then  -- facing left
				distY = tile.pos.y+tile.h/2 - (v.pos.y - v.hitbox_h/2)
			end

	end
	return distY
end




----- Math

function Point_Rectangle_CollisionCheck(x1,y1, x2,y2,w2,h2)
	local check
	if x1 > (x2 - w2/2) and  x1 < (x2 + w2/2) and y1 > (y2 - h2/2) and  y1 < (y2 + h2/2) then
		check = true
	else
		check = false
	end
	return check
end

function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end
