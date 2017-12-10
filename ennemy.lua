
function drawEnnemies()
	if start_new_wave == true then
		for i,v in ipairs(ennemies) do -- draw ennemies

	   --  love.graphics.rectangle("fill",v.pos.x-v.w/2,v.pos.y-v.h/2,v.w,v.h)
	    	if v.IA == 3 then
				love.graphics.draw(SHADOW_IMG,v.pos.x-v.w/2+12, v.pos.y+v.h/2-5, 0, 3, 3,0,0)
			elseif v.IA == 4 or v.IA == 5 then
				--love.graphics.draw(SHADOW_IMG,v.pos.x-v.w/2+12, v.pos.y+v.h/2-5, 0, 3, 3,0,0)	
	    	else
				love.graphics.draw(SHADOW_IMG,v.pos.x-v.w/2+12, v.pos.y+v.h/2, 0, 3, 3,0,0)
			end

			if v.praying == true then
				if v.direction == 1 then
	 				v.anim_pray:draw( v.pos.x-v.w/2, v.pos.y-v.h/2,0, 3*v.direction, 3,0,0)
				else
		 			v.anim_pray:draw( v.pos.x-2*v.w/2, v.pos.y-v.h/2,0, 3*v.direction, 3,v.w/2,0)
				end
			elseif math.sqrt(v.vit.x*v.vit.x+v.vit.y*v.vit.y) < 10 then -- IDLE
	 			if v.direction == 1 then
	 				v.anim_idle:draw( v.pos.x-v.w/2, v.pos.y-v.h/2,0, 3*v.direction, 3,0,0)
				else
		 			v.anim_idle:draw( v.pos.x-2*v.w/2, v.pos.y-v.h/2,0, 3*v.direction, 3,v.w/2,0)
				end
	 		else
	 			if v.direction == 1 then
	 				v.anim_walk:draw( v.pos.x-v.w/2, v.pos.y-v.h/2,0, 3*v.direction, 3,0,0)
				else
		 			v.anim_walk:draw( v.pos.x-2*v.w/2, v.pos.y-v.h/2,0, 3*v.direction, 3,v.w/2,0)
				end
	 		end


	 		for ii,vv in ipairs(v.bullets) do -- Draw bullets of ennemy
	 			vv.anim:draw( vv.pos.x-vv.w/2, vv.pos.y-vv.h/2,0, 3, 3,0,0)
	 			--love.graphics.rectangle("fill",vv.pos.x-vv.w/2,vv.pos.y-vv.h/2,vv.w,vv.h)
			end
		end
	end
end

function computePathtoGoal(pos_start,goal_to_reach)

   local start = {
     x = math.floor(pos_start.x/TILE_W)+1,
     y = math.floor(pos_start.y/TILE_H)+1
   }

   local goal = {
      x = math.floor(goal_to_reach.pos.x/TILE_W)+1,
      y = math.floor(goal_to_reach.pos.y/TILE_H)+1
   }

    local path = astar:findPath(start, goal)
    if not(path== nil) then
  		path_test = path:getNodes()
    end

	return path
end

function updateEnnemies(dt)
	if start_new_wave == true then
		for i,v in pairs(ennemies) do
			-- IA
			local next_local_goal
			if v.path == nil then
				next_local_goal = {x = SHRINE_POS.x , y = SHRINE_POS.y}
			else
				next_local_goal = v.path:getNodes()[1].location

				if distance(v.pos.x,v.pos.y,(next_local_goal.x-0.5)*16*3,(next_local_goal.y-0.5)*16*3) < 50 then
					table.remove(v.path:getNodes(),1)
				end
			end


			if v.IA == 1 then -- pray IA
				if distance(v.pos.x,v.pos.y,shrine.pos.x,shrine.pos.y) < 150 then
					v.praying = true
					if v.path == nil then
							-- Shoot
						if v.canShoot then
							v.canShoot = false
							ShootThePlayer(v) -- create bullet toward player
							v.timerStart = love.timer.getTime()
						end
						if love.timer.getTime() - v.timerStart > v.bullet_reload and v.canShoot == false then
							v.canShoot = true
						end
					end
				end
			elseif v.IA == 2 then -- attack IA
				-- Shoot
				if v.canShoot then
					v.canShoot = false
					ShootThePlayer(v) -- create bullet toward player
					v.timerStart = love.timer.getTime()
				end
				if love.timer.getTime() - v.timerStart > v.bullet_reload and v.canShoot == false then
					v.canShoot = true
				end

				-- update a* path
				v.path = computePathtoGoal(v.pos,player)
			elseif v.IA == 3 then -- Blob IA
				-- Shoot
				if v.canShoot and distance(v.pos.x,v.pos.y,player.pos.x,player.pos.y) < 32*3 then
					v.canShoot = false
					ShootThePlayer(v) -- create bullet toward player
					v.timerStart = love.timer.getTime()
				end
				if love.timer.getTime() - v.timerStart > v.bullet_reload and v.canShoot == false then
					v.canShoot = true
				end

				-- update a* path
				v.path = computePathtoGoal(v.pos,player)
			elseif v.IA == 4 then -- MiniBoss IA
				-- Shoot
				if v.canShoot  then
					v.canShoot = false
					v.isPopping = true
					v.timerStart = love.timer.getTime()
				end
				if love.timer.getTime() - v.timerStart > v.bullet_reload and v.canShoot == false then
					v.canShoot = true
				end

				if v.isPopping then
					if v.canPop  then
						v.canPop = false
						v.timerPopping = love.timer.getTime()
						v.popped = v.popped + 1
						ShootThePlayer(v) -- create bullet toward player
					end
					if love.timer.getTime() - v.timerPopping > v.DELAY_POPPING and v.canPop == false then
						v.canPop = true
					end

					if v.popped > 5 then
						v.isPopping = false
						v.popped = 0
					end
				end
				v.path = computePathtoGoal(v.pos,player)	
			elseif v.IA == 5 then -- MiniBoss IA 
				-- Shoot
				if v.canShoot  then
					v.canShoot = false
					v.isPopping = true
					v.timerStart = love.timer.getTime()
				end
				if love.timer.getTime() - v.timerStart > v.bullet_reload and v.canShoot == false then
					v.canShoot = true
				end

				if v.isPopping then
					if v.canPop  then
						v.canPop = false
						v.timerPopping = love.timer.getTime()
						v.popped = v.popped + 1
						SummonEnnemies(v.pos.x,v.pos.y,1,{ID=3,posx=v.pos.x, posy=v.pos.y}) 
					end
					if love.timer.getTime() - v.timerPopping > v.DELAY_POPPING and v.canPop == false then
						v.canPop = true
					end

					if v.popped > 5 then
						v.isPopping = false
						v.popped = 0
					end					
				end
				v.path = computePathtoGoal(v.pos,player)	
			end

			


			-- MOVEMENT
			if v.praying == false then -- MOVING towards goal
				local diffx = (next_local_goal.x-0.5)*16*3+love.math.random(80)-40 - v.pos.x
				local diffy = (next_local_goal.y-0.5)*16*3+love.math.random(80)-40 - v.pos.y
				local acc_local = ACCELERATION
				if v.IA == 3 then
					acc_local = 3*ACCELERATION
				elseif v.IA == 4 or v.IA == 5 then
					if v.isPopping then
						acc_local = 0
					else
						acc_local = ACCELERATION/2
					end
				end
				if math.abs(diffx)==diffx then
					v.acc.x=acc_local/3.5
				else
					v.acc.x=-acc_local/3.5
				end
				if math.abs(diffy)==diffy then
					v.acc.y=acc_local/3.5
				else
					v.acc.y=-acc_local/3.5
				end

				updateVelocity(v,dt)
			else -- PRAYING
				shrine.being_prayed = true
			end

			-- BULLETS
			for ii,vv in ipairs(v.bullets) do
				vv.pos.x = vv.pos.x + (vv.vit.x * dt)
				vv.pos.y = vv.pos.y + (vv.vit.y * dt)
				vv.anim:update(dt)
				pop_foe_bullet_trail_anim(vv.pos.x-vv.w/2,vv.pos.y-vv.h/2)

				for j,w in ipairs(crates) do
					if Point_Rectangle_CollisionCheck(vv.pos.x,vv.pos.y,w.pos.x,w.pos.y,w.w,w.h) then

						pop_hit_anim(vv.pos.x-11,vv.pos.y-11/2,vv.vit.x,vv.vit.y)
						table.remove(v.bullets,ii)

						w.health = w.health - 1
					end
				end
				if Point_Rectangle_CollisionCheck(vv.pos.x,vv.pos.y,shrine.hitbox_pos.x,shrine.hitbox_pos.y,shrine.hitbox_w,shrine.hitbox_h) then
					pop_hit_anim(vv.pos.x-11,vv.pos.y-11/2,vv.vit.x,vv.vit.y)
					table.remove(v.bullets,ii)
				end
				if Point_Rectangle_CollisionCheck(vv.pos.x,vv.pos.y,player.pos.x,player.pos.y,player.w,player.h) and not(player.dead) then
					player.dead = true

					local SFX = love.audio.newSource("assets/sounds/game_over.wav", "static")
					--SFX:setVolume(0.6)
					SFX:play()
					pop_player_death_anim(player.pos.x,player.pos.y,player.dir)
					timerGameOver = love.timer.getTime()
					LOSE = true
					--GAME_STATE = "LOSE"

				end
				if vv.pos.x < -50 or vv.pos.x > screenWidth+50 or vv.pos.y < -50 or vv.pos.y > screenHeight+ 50 then -- remove out of screen bullets
					table.remove(v.bullets,ii)
				end

			end
			-- Anim

			v.anim_idle:update(dt)
			v.anim_walk:update(dt)
			v.anim_pray:update(dt)

		end
	end
end

function ShootThePlayer( v )
	local startX = v.pos.x
	local startY = v.pos.y
	local targetX = player.pos.x
	local targetY = player.pos.y

	local angle = math.atan2((targetY - startY), (targetX - startX))

	local bulletDx = 0.5*bulletSpeed * math.cos(angle)
	local bulletDy = 0.5*bulletSpeed * math.sin(angle)

	table.insert(v.bullets,{ pos = {x = startX, y = startY}, vit = {x = bulletDx, y = bulletDy}, w=5,h=5,anim = BULLET_FOE_ANIM})
end

function SummonEnnemies(local_x,local_y,nbr,type_en) -- Spawn new Ennemies
	pos_spawn_eff = {}
	for i = 1,nbr do
		local random_dir = love.math.random(4)
		local randomX = love.math.random(screenWidth-20)
		local randomY = love.math.random(screenHeight-20)
		local posx = 1
		local posy = 1

		local duplicate = false -- AVOIDS DUPLICATE SPAWN DIRECTION
		for i,v in ipairs(pos_spawn_eff) do
			if pos_spawn[random_dir] == pos_spawn_eff[i] then
				duplicate = true
			end
		end
		if not(duplicate) then
			table.insert(pos_spawn_eff,pos_spawn[random_dir])

		end


		if pos_spawn[random_dir] == 1 then -- left edge
			pop_arrow_anim(CAM_X0  		+ 57*3/2		,SHRINE_POS.y*TILE_H + 57*3/2,-math.pi/2) -- left
			posx = 20
			posy = randomY+love.math.random(10)
		elseif pos_spawn[random_dir] == 2 then -- up edge
			pop_arrow_anim(SHRINE_POS.x*TILE_W 	- 36*3/2		,0 				,0) -- up
			posx = randomX+love.math.random(10)
			posy = 20
		elseif pos_spawn[random_dir] == 3 then -- right edge
			pop_arrow_anim(screenWidth - CAM_X0 - 3*57*3/2 ,SHRINE_POS.y*TILE_H  		,math.pi/2) -- right
			posx = screenWidth-20
			posy = randomY+love.math.random(10)
		elseif pos_spawn[random_dir] == 4 then -- down edge
			pop_arrow_anim(SHRINE_POS.x*TILE_W	+ 36*3/2		,screenHeight-CAM_Y0 - 57*3	,math.pi) -- down
			posx = randomX+love.math.random(10)
			posy = screenHeight-20
		end

		local random= love.math.random(2)
		local random_IA =  love.math.random(5)
		if not(type_en == nil) then 
			random_IA = type_en.ID
			posx = type_en.posx -love.math.random(32*2) + love.math.random(64*2)
			posy = type_en.posy -love.math.random(32*2) + love.math.random(64*2)
		end

		local ENNEMY_idle = nil
		local ENNEMY_walk = nil
		local ENNEMY_pray = nil

		local width = 10
		local height = 10
		local br = 4
		if random_IA == 1 then
			ENNEMY_idle = newAnimation(FOE1_IDLE_ANIM_IMG, 12, 22, 0.1, 0)
			ENNEMY_idle:setMode("loop")
			ENNEMY_walk = newAnimation(FOE1_WALK_ANIM_IMG, 12, 22, 0.2, 0)
			ENNEMY_walk:setMode("loop")
			ENNEMY_pray = newAnimation(FOE1_PRAY_ANIM_IMG, 12, 22, 0.5, 0)
			ENNEMY_pray:setMode("loop")

			width = 3*12
			height = 3*20
		elseif random_IA == 2 then
			ENNEMY_idle = newAnimation(FOE2_IDLE_ANIM_IMG, 12, 22, 0.1, 0)
			ENNEMY_idle:setMode("loop")
			ENNEMY_walk = newAnimation(FOE2_WALK_ANIM_IMG, 12, 22, 0.2, 0)
			ENNEMY_walk:setMode("loop")
			ENNEMY_pray = newAnimation(FOE1_PRAY_ANIM_IMG, 12, 22, 0.2, 0)
			ENNEMY_pray:setMode("loop")

			width = 3*12
			height = 3*20
		elseif random_IA == 3 then --  BLOB
			ENNEMY_idle = newAnimation(BLOB_WALK_ANIM_IMG, 12, 12, 0.1, 0)
			ENNEMY_idle:setMode("loop")
			ENNEMY_walk = newAnimation(BLOB_WALK_ANIM_IMG, 12, 12, 0.2, 0)
			ENNEMY_walk:setMode("loop")
			ENNEMY_pray = newAnimation(FOE1_PRAY_ANIM_IMG, 12, 12, 0.2, 0)
			ENNEMY_pray:setMode("loop")

			width = 3*12
			height = 3*12
			br = 2
		elseif random_IA == 4 then -- Miniboss shoot
			ENNEMY_idle = newAnimation(MINIBOSS_IDLE_ANIM_IMG, 25, 31, 0.1, 0)
			ENNEMY_idle:setMode("loop")
			ENNEMY_walk = newAnimation(MINIBOSS_WALK_ANIM_IMG, 25, 31, 0.2, 0)
			ENNEMY_walk:setMode("loop")
			ENNEMY_pray = newAnimation(MINIBOSS_WALK_ANIM_IMG, 25, 31, 0.2, 0)
			ENNEMY_pray:setMode("loop")

			width = 3*25
			height = 3*31	
			br = 10
		elseif random_IA == 5 then -- Miniboss spawn
			ENNEMY_idle = newAnimation(MINIBOSS2_IDLE_ANIM_IMG, 25, 31, 0.1, 0)
			ENNEMY_idle:setMode("loop")
			ENNEMY_walk = newAnimation(MINIBOSS2_WALK_ANIM_IMG, 25, 31, 0.2, 0)
			ENNEMY_walk:setMode("loop")
			ENNEMY_pray = newAnimation(MINIBOSS2_WALK_ANIM_IMG, 25, 31, 0.2, 0)
			ENNEMY_pray:setMode("loop")

			width = 3*25
			height = 3*31	
			br = 10	
		end

		local newEnnemy = {
			pos = {x = posx, y=posy}, -- position
			vit = {x = 0, y = 0}, -- vitesse,
			acc = {x = 0, y = 0}, -- acceleration,
			direction = -1, -- "1=right", "-1=left"

			anim_idle = ENNEMY_idle,
			anim_walk = ENNEMY_walk,
			anim_pray = ENNEMY_pray,
			w = width,
			h =  height,
			hitbox_w= 3*10,
			hitbox_h=3*16,

			IA = random_IA,
			path = computePathtoGoal({x = posx, y=posy},shrine),
			praying = false,
			bullets = {},

			bullet_reload = br+math.random(0,3),
			canShoot = true,
			timerStart = love.timer.getTime(),

			timerStartDust = love.timer.getTime(),
			DELAY_POP_DUST = 0.19,
			popdust = true,

			timerPopping = love.timer.getTime(),
			isPopping = false,
			DELAY_POPPING = 0.5,
			canPop = false,
			popped = 0

	}
	table.insert(ennemies, newEnnemy)
	end
end


function Ennemy_hit(ennemy,damage,table_id)
	score = score + 1

	if ennemy.praying == true then
		shrine.being_prayed = false
	end
	pop_pickup_anim(ennemy.pos.x,ennemy.pos.y)
	pop_foe_death_anim(ennemy.pos.x,ennemy.pos.y,ennemy.direction,ennemy.IA)
	table.remove(ennemies,table_id)

end
