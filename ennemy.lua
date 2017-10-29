
function drawEnnemies()
	for i,v in ipairs(ennemies) do -- draw ennemies
    	
    	-- love.graphics.rectangle("fill",v.pos.x-v.w/2,v.pos.y-v.h/2,v.w,v.h)
		love.graphics.draw(SHADOW_IMG,v.pos.x-v.w/2+10, v.pos.y+v.h/2, 0, 3, 3,0,0)
		
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
					if love.timer.getTime() - v.timerStart > bullet_reload+math.random(0,3) and v.canShoot == false then
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
			if love.timer.getTime() - v.timerStart > bullet_reload+math.random(0,3) and v.canShoot == false then
				v.canShoot = true
			end

			-- update a* path
			v.path = computePathtoGoal(v.pos,player) 
		end


		-- MOVEMENT
		if v.praying == false then -- MOVING towards goal
			local diffx = (next_local_goal.x-0.5)*16*3+love.math.random(80)-40 - v.pos.x
			local diffy = (next_local_goal.y-0.5)*16*3+love.math.random(80)-40 - v.pos.y
			if math.abs(diffx)==diffx then
				v.acc.x=ACCELERATION/3.5
			else
				v.acc.x=-ACCELERATION/3.5
			end
			if math.abs(diffy)==diffy then
				v.acc.y=ACCELERATION/3.5
			else
				v.acc.y=-ACCELERATION/3.5
			end

			updateVelocity(v,dt)
		else -- PRAYING
			shrine.loaded = shrine.loaded + 0.1*dt
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
			if Point_Rectangle_CollisionCheck(vv.pos.x,vv.pos.y,player.pos.x,player.pos.y,player.w,player.h) then
				player.dead = true

				local SFX = love.audio.newSource("assets/sounds/game_over.wav", "static")
				--SFX:setVolume(0.6)
				SFX:play()

				GAME_STATE = "LOSE"
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

function ShootThePlayer( v )
	local startX = v.pos.x 
	local startY = v.pos.y 
	local targetX = player.pos.x
	local targetY = player.pos.y
 
	local angle = math.atan2((targetY - startY), (targetX - startX))
 
	local bulletDx = bulletSpeed * math.cos(angle)
	local bulletDy = bulletSpeed * math.sin(angle)
 
	table.insert(v.bullets,{ pos = {x = startX, y = startY}, vit = {x = bulletDx, y = bulletDy}, w=5,h=5,anim = BULLET_FOE_ANIM})
end
function SummonEnnemies(local_x,local_y,nbr) -- Spawn new Ennemies
	
	for i = 1,nbr do
		local random = love.math.random(4)
		local random_IA =  love.math.random(2)
		local randomX = love.math.random(screenWidth-20)
		local randomY = love.math.random(screenHeight-20)
		local posx = 1
		local posy = 1
		if random == 1 then -- left edge
			posx = 20
			posy = randomY+love.math.random(10)
		elseif random == 2 then -- right edge\
			posx = screenWidth-20
			posy = randomY+love.math.random(10)
		elseif random == 3 then -- down edge 
			posx = randomX+love.math.random(10)
			posy = screenHeight-20
		elseif random == 4 then -- up edge
			posx = randomX+love.math.random(10)
			posy = 20
		end

		local ENNEMY_1_idle 
		local ENNEMY_1_walk
		local ENNEMY_1_pray

		if random_IA == 1 then
			ENNEMY_1_idle = newAnimation(love.graphics.newImage("assets/foe1_idle.png"), 12, 22, 0.1, 0)
			ENNEMY_1_idle:setMode("loop")
			ENNEMY_1_walk = newAnimation(love.graphics.newImage("assets/foe1_walk.png"), 12, 22, 0.2, 0)
			ENNEMY_1_walk:setMode("loop")
			ENNEMY_1_pray = newAnimation(love.graphics.newImage("assets/foe1_pray.png"), 12, 22, 0.5, 0)
			ENNEMY_1_pray:setMode("loop")
		elseif random_IA == 2 then
			ENNEMY_1_idle = newAnimation(love.graphics.newImage("assets/foe2_idle.png"), 12, 22, 0.1, 0)
			ENNEMY_1_idle:setMode("loop")
			ENNEMY_1_walk = newAnimation(love.graphics.newImage("assets/foe2_walk.png"), 12, 22, 0.2, 0)
			ENNEMY_1_walk:setMode("loop")
			ENNEMY_1_pray = newAnimation(love.graphics.newImage("assets/foe1_pray.png"), 12, 22, 0.2, 0)
			ENNEMY_1_pray:setMode("loop")
		end

		local newEnnemy = {	
			pos = {x = posx, y=posy}, -- position
			vit = {x = 0, y = 0}, -- vitesse,
			acc = {x = 0, y = 0}, -- acceleration,
			direction = -1, -- "1=right", "-1=left"

			anim_idle = ENNEMY_1_idle,
			anim_walk = ENNEMY_1_walk,
			anim_pray = ENNEMY_1_pray,
			w = 3*12,
			h =  3*20,
			hitbox_w= 3*10,
			hitbox_h=3*16,

			IA = random_IA,	
			path = computePathtoGoal({x = posx, y=posy},shrine),
			praying = false,
			bullets = {},	
			canShoot = true,
			timerStart = love.timer.getTime()
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