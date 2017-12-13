
anims = {}	 -- array of anims
bgs = {} 	 -- array of moving backgrounds
whiteflicker = false
whiteflicker_timer = 0

Nbr_anims = 0

-- Loading
function loadImg()

	love.graphics.setDefaultFilter('nearest','nearest')

	PLAYER_idle = newAnimation(love.graphics.newImage("assets/player_idle.png"), 12, 22, 0.1, 0)
	PLAYER_idle:setMode("loop")

	PLAYER_walk = newAnimation(love.graphics.newImage("assets/player_walk.png"), 12, 22, 0.08, 0)
	PLAYER_walk:setMode("loop")

	BOX_IMG = love.graphics.newImage('assets/box.png')
	BOX_SHADOW_IMG = love.graphics.newImage('assets/box_shadow.png')
	BOX_D1_IMG = love.graphics.newImage('assets/box_d1.png')
	BOX_D2_IMG = love.graphics.newImage('assets/box_d2.png')
	BOX_D3_IMG = love.graphics.newImage('assets/box_d3.png')
	BOX_D4_IMG = love.graphics.newImage('assets/box_d4.png')
	ITEM_SHADOW_IMG = love.graphics.newImage('assets/item_shadow.png')
	BG_IMG = love.graphics.newImage('assets/bg.png')
	MENU_TILE_IMG = love.graphics.newImage('assets/menu_tile.png')
	MASK_IMG = love.graphics.newImage('assets/mask.png')
	SHADOW_IMG = love.graphics.newImage('assets/shadow.png')
	SHRINE_IMG = love.graphics.newImage('assets/shrine.png')
	SHRINE_TOP_IMG = love.graphics.newImage('assets/shrine_top.png')
	SHRINE_BOT_IMG = love.graphics.newImage('assets/shrine_bot.png')
	SHRINE_SHADOW_IMG = love.graphics.newImage('assets/shrine_shadow.png')
	CROSSHAIR_IMG = love.image.newImageData('assets/crosshair.png')

	MASK_ANIM = newAnimation(love.graphics.newImage("assets/mask-anim.png"), 115, 211, 0.2, 0)
	MASK_ANIM:setMode("loop")

	MOUSE_LEFT_ANIM = newAnimation(love.graphics.newImage("assets/control_mouse_left_anim.png"), 18, 26, 0.5, 0)
	MOUSE_LEFT_ANIM:setMode("loop")
	MOUSE_RIGHT_ANIM = newAnimation(love.graphics.newImage("assets/control_mouse_right_anim.png"), 18, 26, 0.5, 0)
	MOUSE_RIGHT_ANIM:setMode("loop")
	KEYS_ANIM = newAnimation(love.graphics.newImage("assets/control_keys_anim.png"), 62, 40, 0.5, 0)
	KEYS_ANIM:setMode("loop")

	SHRINE_ANIM = newAnimation(love.graphics.newImage("assets/shrine_anim.png"), 46, 78, 0.2, 0)
	SHRINE_ANIM:setMode("loop")
	SHRINE_TOP_ANIM = newAnimation(love.graphics.newImage("assets/shrine_anim_top.png"), 46, 78, 0.2, 0)
	SHRINE_TOP_ANIM:setMode("loop")
	SHRINE_BOT_ANIM = newAnimation(love.graphics.newImage("assets/shrine_anim_bot.png"), 46, 78, 0.2, 0)
	SHRINE_BOT_ANIM:setMode("loop")

	BULLET_ANIM = newAnimation(love.graphics.newImage("assets/bullet.png"), 7, 7, 1, 0)
	BULLET_ANIM:setMode("loop")

	BULLET_FOE_ANIM = newAnimation(love.graphics.newImage("assets/bullet_foe.png"), 7, 7, 1, 0)
	BULLET_FOE_ANIM:setMode("loop")

	ARROW_ANIM_IMG = love.graphics.newImage("assets/arrow_wave_anim.png")
	HIT_ANIM_IMG = love.graphics.newImage("assets/hit_anim.png")
	CRATE_ANIM_IMG = love.graphics.newImage("assets/box-pop.png")
	DUST_ANIM_IMG = love.graphics.newImage("assets/dust.png")
	PICKUP_ANIM_IMG = love.graphics.newImage("assets/pickup.png")
	BULLET_TRAIL_ANIM_IMG = love.graphics.newImage("assets/bullet_trail.png")
	ITEM_ANIM_IMG = love.graphics.newImage("assets/item.png")
	POWERUP1_ANIM_IMG = love.graphics.newImage("assets/power_up_laser.png")
	POWERUP2_ANIM_IMG = love.graphics.newImage("assets/power_up_minigun.png")
	POWERUP3_ANIM_IMG = love.graphics.newImage("assets/power_up_rocket.png")
	POWERUP4_ANIM_IMG = love.graphics.newImage("assets/power_up_shotgun.png")
	POWERUP5_ANIM_IMG = love.graphics.newImage("assets/power_up_shield.png")

	UI_IMG = love.graphics.newImage("assets/UI.png")
	TORCH_IMG = love.graphics.newImage("assets/torche.png")
	TORCH_SHADOW_IMG = love.graphics.newImage("assets/torche_shadow.png")
	TORCH_ANIM_IMG = love.graphics.newImage("assets/torche_anim.png")

	SHRINE_COMPLETE_IMG = {
		love.graphics.newImage("assets/shrine_complete_1.png"),
		love.graphics.newImage("assets/shrine_complete_2.png"),
		love.graphics.newImage("assets/shrine_complete_3.png"),
		love.graphics.newImage("assets/shrine_complete_4.png"),
		love.graphics.newImage("assets/shrine_complete_5.png"),
		love.graphics.newImage("assets/shrine_complete_6.png"),
		love.graphics.newImage("assets/shrine_complete_7.png"),
		love.graphics.newImage("assets/shrine_complete_8.png"),
		love.graphics.newImage("assets/shrine_complete_9.png"),
		love.graphics.newImage("assets/shrine_complete_10.png"),
		love.graphics.newImage("assets/shrine_complete_11.png"),
		love.graphics.newImage("assets/shrine_complete_12.png"),
	}

	FOE_BULLET_TRAIL_ANIM_IMG = love.graphics.newImage("assets/bullet_foe_trail.png")
	FOE1_DEATH_ANIM_IMG = love.graphics.newImage("assets/foe1_death.png")
	FOE2_DEATH_ANIM_IMG = love.graphics.newImage("assets/foe2_death.png")
	PLAYER_DEATH_ANIM_IMG = love.graphics.newImage("assets/player_death.png")
	BLOB_DEATH_ANIM_IMG = love.graphics.newImage("assets/blob_death.png")

	FOE1_IDLE_ANIM_IMG = love.graphics.newImage("assets/foe1_idle.png")
	FOE1_WALK_ANIM_IMG = love.graphics.newImage("assets/foe1_walk.png")
	FOE1_PRAY_ANIM_IMG = love.graphics.newImage("assets/foe1_pray.png")
	FOE2_IDLE_ANIM_IMG = love.graphics.newImage("assets/foe2_idle.png")
	FOE2_WALK_ANIM_IMG = love.graphics.newImage("assets/foe2_walk.png")
	BLOB_WALK_ANIM_IMG = love.graphics.newImage("assets/blob_walk.png")
	MINIBOSS_IDLE_ANIM_IMG = love.graphics.newImage("assets/miniboss_idle.png")
	MINIBOSS_WALK_ANIM_IMG = love.graphics.newImage("assets/miniboss_walk.png")
	MINIBOSS2_IDLE_ANIM_IMG = love.graphics.newImage("assets/miniboss2_idle.png")
	MINIBOSS2_WALK_ANIM_IMG = love.graphics.newImage("assets/miniboss2_walk.png")

	-- for i = 1,5 do
	-- 	for j = 1,5 do

	-- 		animImg = newAnimation(love.graphics.newImage("assets/grass.png"), 8,8, 0.3, 0)
	-- 		animImg:setMode("loop")
	-- 		table.insert(anims,{ x = math.random(screenWidth), y = math.random(screenHeight) , animation = animImg, scaleX =3, scaleY = 3,loop = true})
	-- 	end
	-- end


end

function loadSound()
	music = love.audio.newSource("assets/sounds/music.mp3")
	music:setLooping(true)                            -- all instances will be looping
	music:play()

	pickup_item_SFX = love.audio.newSource("assets/sounds/pickup_item.wav", "static")

	--	pickup_item_SFX:play()

	-- hit_SFX = love.audio.newSource("assets/sounds/hit.wav", "static")
	-- shoot_SFX = love.audio.newSource("assets/sounds/shoot.wav", "static")
	-- xplosion_SFX = love.audio.newSource("assets/sounds/xplosion.wav", "static")
	-- hitsheep_SFX = love.audio.newSource("assets/sounds/rdm8.wav", "static")
	-- coin_SFX = love.audio.newSource("assets/sounds/coin.wav", "static")

	-- muteSounds()
end

function muteSounds()
	 music:setVolume(0)
	-- coin_SFX:setVolume(0)
	-- hitsheep_SFX:setVolume(0)
	-- xplosion_SFX:setVolume(0)
	-- shoot_SFX:setVolume(0)
	-- hit_SFX:setVolume(0)
	-- jump_SFX:setVolume(0)
end

function resumeSounds()
 --    music:setVolume(1)
	-- coin_SFX:setVolume(0.3)
	-- hitsheep_SFX:setVolume(0.3)
	-- xplosion_SFX:setVolume(0.3)
	-- shoot_SFX:setVolume(0.4)
	-- hit_SFX:setVolume(0.4)
	-- jump_SFX:setVolume(0.3)
end

function FX_whiteflicker() -- Flashes white the screen
	whiteflicker = true
	whiteflicker_timer = 0.066 -- duration of white screen
end

function pop_hit_anim(x,y,vx,vy)
	local angle_loc = math.atan2(vy*10, vx*10)
	animImg = newAnimation(HIT_ANIM_IMG, 11,11, 0.05, 0)
	animImg:setMode("once")
	table.insert(anims,{ pos={x = x, y = y }, vit = {x=0,y=0}, animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0,display_top = true}) -- NO ROTATION

	local hit_impact_SFX = love.audio.newSource("assets/sounds/hit_impact.wav", "static")
	hit_impact_SFX:setVolume(0.6)
	hit_impact_SFX:play()

	camera.shakedir = angle_loc
	camera.shaketype = "shooting"
end


function pop_crate_anim(posx,posy)
	animImg = newAnimation(CRATE_ANIM_IMG, 23,23, 0.05, 0)
	animImg:setMode("once")
	table.insert(anims,{ pos={x = posx-34, y = posy-36}, vit={x=0,y=0} , animation = animImg, scaleX =3, scaleY = 3,loop=false,angle=0,display_top = true})
end

function pop_torch_anim(posx,posy)
	animImg = newAnimation(TORCH_ANIM_IMG, 5,28, 0.05, 0)
	animImg:setMode("loop")
	table.insert(anims,{ pos={x = posx, y = posy}, vit={x=0,y=0} , animation = animImg, scaleX =3, scaleY = 3,loop=true,angle=0,display_top = true})
end

function pop_dust_anim(x,y,dir)
	--local angle_loc = math.atan2(vy*10, vx*10)
	animImg = newAnimation(DUST_ANIM_IMG, 11,11, 0.09, 0)
	animImg:setMode("once")
	local dis_top = true
	if math.random(2) == 2 then
		dis_top = false
	end

	table.insert(anims,{ pos = {x = x-11, y = y-14 }, vit = {x=-dir*math.random(80),y=-math.random(80)},animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0,display_top = dis_top})
end

function pop_arrow_anim(x,y,angle_loc)

	animImg = newAnimation(ARROW_ANIM_IMG, 36, 57, 0.2, 0)
	animImg:setMode("loop")
	table.insert(anims,{ pos={x = x,y = y }, vit = {x=0,y=0}, animation = animImg, scaleX =3, scaleY = 3,loop=true,angle = angle_loc,display_top = true})
end

function pop_pickup_anim(x,y)

	animImg = newAnimation(PICKUP_ANIM_IMG, 11,11, 0.05, 0)
	animImg:setMode("once")
	table.insert(anims,{ pos={x = x, y = y },  vit = {x=0,y=0},animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0, display_top = true})
end

function pop_bullet_trail_anim(x,y)
	--local angle_loc = math.atan2(vy*10, vx*10)
	animImg = newAnimation(BULLET_TRAIL_ANIM_IMG, 7,7, 0.045, 0)
	animImg:setMode("once")
	table.insert(anims,{ pos={x = x, y = y} , vit = {x=0,y=0}, animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0,display_top = false})
end

function pop_foe_bullet_trail_anim(x,y)
	--local angle_loc = math.atan2(vy*10, vx*10)
	animImg = newAnimation(FOE_BULLET_TRAIL_ANIM_IMG, 7,7, 0.07, 0)
	animImg:setMode("once")
	table.insert(anims,{pos={ x = x, y = y }, vit = {x=0,y=0} ,animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0,display_top = false})
end

function pop_player_death_anim(x,y,dir )

	local SFX = love.audio.newSource("assets/sounds/foe_death.wav", "static")
	--SFX:setVolume(0.6)
	SFX:play()

	local animImg

	animImg = newAnimation(PLAYER_DEATH_ANIM_IMG, 22,26, 0.22, 0)


	animImg:setMode("once")


	if dir == 1 then
		table.insert(anims,{pos={ x = x+3*9, y = y-3*13 }, vit = {x=0,y=0} ,animation = animImg, scaleX =-3, scaleY = 3,loop=true,angle = 0,display_top = true})
	else
		table.insert(anims,{ pos={x = x-3*9, y = y - 3*13} , vit = {x=0,y=0},animation = animImg, scaleX =3, scaleY = 3,loop=true,angle = 0,display_top = true})
	end
end
function pop_foe_death_anim(x,y,dir,typeIA)
	--local angle_loc = math.atan2(vy*10, vx*10)

	local SFX = love.audio.newSource("assets/sounds/foe_death.wav", "static")
	--SFX:setVolume(0.6)
	SFX:play()

	local animImg
	if typeIA == 1 then
		animImg = newAnimation(FOE1_DEATH_ANIM_IMG, 22,26, 0.1, 0)
	elseif typeIA == 2 then
		animImg = newAnimation(FOE2_DEATH_ANIM_IMG, 22,26, 0.1, 0)
	elseif typeIA == 3 then
		animImg = newAnimation(BLOB_DEATH_ANIM_IMG, 12,16, 0.1, 0)
	elseif typeIA == 4 then
		animImg = newAnimation(BLOB_DEATH_ANIM_IMG, 12,16, 0.1, 0)
	elseif typeIA == 5 then
		animImg = newAnimation(BLOB_DEATH_ANIM_IMG, 12,16, 0.1, 0)
	end

	animImg:setMode("once")

	if typeIA == 3 then
		if dir == 1 then
			table.insert(anims,{ pos={x = x-3*6, y = y - 3*8} , vit = {x=0,y=0},animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0,display_top = true})
		else
			table.insert(anims,{pos={ x = x+3*6, y = y-3*8}, vit = {x=0,y=0} ,animation = animImg, scaleX =-3, scaleY = 3,loop=false,angle = 0,display_top = true})
		end
	else
		if dir == 1 then
			table.insert(anims,{ pos={x = x-3*9, y = y - 3*13} , vit = {x=0,y=0},animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0,display_top = true})
		else
			table.insert(anims,{pos={ x = x+3*9, y = y-3*13 }, vit = {x=0,y=0} ,animation = animImg, scaleX =-3, scaleY = 3,loop=false,angle = 0,display_top = true})
		end
	end
end

function updateFX(dt)

	Nbr_anims = 0
	-- Update animations
	for i, anim in ipairs(anims) do
		Nbr_anims = Nbr_anims + 1
		anim.animation:update(dt)
		anim.pos.x = anim.pos.x + anim.vit.x * dt
		anim.pos.y = anim.pos.y + anim.vit.y * dt
		if anim.animation.img == ARROW_ANIM_IMG then
			if anim.angle == 0 then
				anim.pos.y = anim.pos.y + math.cos(10*love.timer.getTime())
			elseif anim.angle == math.pi then
				anim.pos.y = anim.pos.y + math.sin(10*love.timer.getTime())
			elseif anim.angle == -math.pi/2 then
				anim.pos.x = anim.pos.x + math.sin(10*love.timer.getTime())
			elseif anim.angle == math.pi/2 then
				anim.pos.x = anim.pos.x + math.cos(10*love.timer.getTime())
			end
			if start_new_wave == true then -- remove ARROWs when new wave starts
				table.remove(anims,i)
			end
		end
		if anim.animation:getCurrentFrame() == anim.animation:getSize() and anim.loop == false then
			table.remove(anims,i)
		end
	end

	-- Update flicker
	if whiteflicker_timer < 0 then
		whiteflicker = false
	else
		whiteflicker_timer = whiteflicker_timer - dt
	end

	-- Update the backgrounds
	for i, bg in ipairs(bgs) do
		bg.x1 = bg.x1 - (bg.speed)*dt
		bg.x2 = bg.x2 - (bg.speed)*dt
		if(bg.x1 + bg.width < 0) then
			bg.x1 = bg.x2 + bg.width
		elseif (bg.x2 + bg.width < 0) then
			bg.x2 = bg.x1 + bg.width
		end
		--if bg.x1 < -250 then
		--	bg.x1 = screenWidth
		--end
	end

	-- if x1 < -250 then
	-- 	x1 = screenWidth
	-- end
	-- if x2 < -250 then
	-- 	x2 = screenWidth
	-- end
end

function drawFXTop()

	-- Draw Animations
	for i, anim in ipairs(anims) do
		if anim.display_top == true then
			anim.animation:draw(anim.pos.x,anim.pos.y,anim.angle,anim.scaleX,anim.scaleY,0,0)
		end
	end

	-- Draw arrows to indicate spawn location
	if display_arrow then
		local time_left = math.floor(TIME_START_WAVE - (love.timer.getTime() - timerStartWaves)+0.5)

		useCustomFont(120)
		love.graphics.setColor(0,0,0)
		love.graphics.printf(tostring(time_left),screenWidth/3.25+6,screenHeight/6.5+6,500,'center')
		love.graphics.setColor(255,255,255)
		love.graphics.printf(tostring(time_left),screenWidth/3.25,screenHeight/6.5,500,'center')

	end
	-- Draw flicker
	if whiteflicker then
		love.graphics.setColor(255,255,255,160)
		love.graphics.rectangle("fill", camera.x, camera.y, screenWidth, screenHeight)
		love.graphics.setColor(255,255,255)
	end
end

function drawFXBot()

	-- Draw Animations
	for i, anim in ipairs(anims) do
		if anim.display_top == false then
			anim.animation:draw(anim.pos.x,anim.pos.y,anim.angle,anim.scaleX,anim.scaleY,0,0)
		end
	end

end

function  drawTorches( )
	local radius = 50*3 -- hardcoded also in ennemy
	for i, v in ipairs(torches) do
		local angle = (i-1)*2*math.pi/8 +math.pi/2
		local posx = shrine.pos.x + radius*math.cos(angle)
		local posy = shrine.pos.y + radius*math.sin(angle)
		love.graphics.draw(TORCH_IMG,posx,posy,0,3,3)
		love.graphics.draw(TORCH_SHADOW_IMG,posx+5,posy+78,0,3,3)

		if nbr == i and  token > 0 then
			token = token - 1
			pop_torch_anim(posx,posy)
		end
	end

end

function  drawArt( )
		-- -- map1. (1,1)

		-- for i, bg in ipairs(bgs) do
		-- 	love.graphics.draw(bg.img,bg.x1,bg.y)
		-- 	love.graphics.draw(bg.img,bg.x2,bg.y)
		-- end

		-- love.graphics.draw(mountain,218+screenWidth/2,66)
		-- love.graphics.draw(bg1,0+screenWidth/2,175)
		-- love.graphics.draw(tree1,69+screenWidth/2,130)
		-- love.graphics.draw(tree2,screenWidth/2,134)
		-- love.graphics.draw(apple,105+screenWidth/2,156)
		-- love.graphics.draw(apple,88+screenWidth/2,148)
		-- love.graphics.draw(apple,74+screenWidth/2,167)
		-- love.graphics.draw(apple,50+screenWidth/2,147)

end
