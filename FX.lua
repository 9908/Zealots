
anims = {}	 -- array of anims
bgs = {} 	 -- array of moving backgrounds
whiteflicker = false
whiteflicker_timer = 0


-- Loading
function loadImg()

	love.graphics.setDefaultFilter('nearest','nearest')

	PLAYER_idle = newAnimation(love.graphics.newImage("assets/player_idle.png"), 12, 22, 0.1, 0)
	PLAYER_idle:setMode("loop")

	PLAYER_walk = newAnimation(love.graphics.newImage("assets/player_walk.png"), 12, 22, 0.1, 0)
	PLAYER_walk:setMode("loop")

	BOX_IMG = love.graphics.newImage('assets/box.png')
	BOX_SHADOW_IMG = love.graphics.newImage('assets/box_shadow.png')
	BOX_DAMAGED_IMG = love.graphics.newImage('assets/box_damaged.png')
	ITEM_SHADOW_IMG = love.graphics.newImage('assets/item_shadow.png')
	BG_IMG = love.graphics.newImage('assets/bg.png')
	MENU_TILE_IMG = love.graphics.newImage('assets/menu_tile.png')
	MASK_IMG = love.graphics.newImage('assets/mask.png')
	SHADOW_IMG = love.graphics.newImage('assets/shadow.png')
	SHRINE_IMG = love.graphics.newImage('assets/shrine.png')
	SHRINE_TOP_IMG = love.graphics.newImage('assets/shrine_top.png')
	SHRINE_BOT_IMG = love.graphics.newImage('assets/shrine_bot.png')
	SHRINE_SHADOW_IMG = love.graphics.newImage('assets/shrine_shadow.png')

	MASK_ANIM = newAnimation(love.graphics.newImage("assets/mask-anim.png"), 115, 211, 0.2, 0)
	MASK_ANIM:setMode("loop")

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
	-- music:setVolume(0)	
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
	animImg = newAnimation(love.graphics.newImage("assets/hit_anim.png"), 11,11, 0.05, 0)
	animImg:setMode("once")				
	table.insert(anims,{ x = x, y = y , animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0}) -- NO ROTATION

	local hit_impact_SFX = love.audio.newSource("assets/sounds/hit_impact.wav", "static")
	hit_impact_SFX:setVolume(0.6)
	hit_impact_SFX:play()
	
	camera.shakedir = angle_loc
	camera.shaketype = "shooting"
end

function pop_dust_anim(x,y)
	--local angle_loc = math.atan2(vy*10, vx*10)
	animImg = newAnimation(love.graphics.newImage("assets/dust.png"), 11,11, 0.07, 0)
	animImg:setMode("once")				
	table.insert(anims,{ x = x-5, y = y+5 , animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0})
end

function pop_pickup_anim(x,y)
	
	animImg = newAnimation(love.graphics.newImage("assets/pickup.png"), 11,11, 0.05, 0)
	animImg:setMode("once")
	table.insert(anims,{ x = x, y = y , animation = animImg, scaleX =3, scaleY = 3,loop=false})
end

function pop_bullet_trail_anim(x,y)
	--local angle_loc = math.atan2(vy*10, vx*10)
	animImg = newAnimation(love.graphics.newImage("assets/bullet_trail.png"), 7,7, 0.045, 0)
	animImg:setMode("once")				
	table.insert(anims,{ x = x, y = y , animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0})
end

function pop_foe_bullet_trail_anim(x,y)
	--local angle_loc = math.atan2(vy*10, vx*10)
	animImg = newAnimation(love.graphics.newImage("assets/bullet_foe_trail.png"), 7,7, 0.07, 0)
	animImg:setMode("once")				
	table.insert(anims,{ x = x, y = y , animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0})
end

function pop_foe_death_anim(x,y,dir,typeIA)
	--local angle_loc = math.atan2(vy*10, vx*10)

	local SFX = love.audio.newSource("assets/sounds/foe_death.wav", "static")
	--SFX:setVolume(0.6)
	SFX:play()

	local animImg
	if typeIA == 1 then 
		animImg = newAnimation(love.graphics.newImage("assets/foe1_death.png"), 22,26, 0.1, 0)
	else
		animImg = newAnimation(love.graphics.newImage("assets/foe2_death.png"), 22,26, 0.1, 0)
	end

	animImg:setMode("once")				
	if dir == 1 then
		table.insert(anims,{ x = x-3*9, y = y - 3*13 , animation = animImg, scaleX =3, scaleY = 3,loop=false,angle = 0})
	else
		table.insert(anims,{ x = x+3*9, y = y-3*13 , animation = animImg, scaleX =-3, scaleY = 3,loop=false,angle = 0})
	end
end

function updateFX(dt) 

	-- Update animations
	for i, anim in ipairs(anims) do
		anim.animation:update(dt) 
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

function drawFX()

	-- Draw Animations
	for i, anim in ipairs(anims) do
		anim.animation:draw(anim.x,anim.y,anim.angle,anim.scaleX,anim.scaleY,0,0)
	end

	-- Draw flicker
	if whiteflicker then
		love.graphics.setColor(255,255,255,160)
		love.graphics.rectangle("fill", camera.x, camera.y, screenWidth, screenHeight)
		love.graphics.setColor(255,255,255)
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
