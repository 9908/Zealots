﻿require("utilities")
require("player")
require("ennemy")
require("crates")
require("item")
require("shrine")
require("AnAL")
require("waves")
require("text")
require("FX")
require("camera")
require('table_tools')
require("leaderboard_fun")

require ("astar")
require ("class")
require ("examplemaphandler")
require ("middleclass")
require ("profiler")
require ("tiledmaphandler")

require ("middleclass")
require ("middleclass")
require ("middleclass")


debug = true

GAME_STATE = "START_MENU" -- START_MENU, PLAY - LOSE - WIN
SHOW_GRID = false

TILE_W = 16*3
TILE_H = 16*3
I_max = 36
J_max = 20

screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

VIT_MAX = 200
friction_mu = 0.01
ACCELERATION = 1000

bulletSpeed = 500
bullet_reload = 4

leaderboard = {}
score = 0
wave = 0 							-- Current wave numbering

time = 0
txt_size = 60 + 20*math.sin(time)

SHRINE_POS = {x = (I_max-1)/2 , y=(J_max-1)/2 }

LOSE = false
timerGameOver = love.timer.getTime()
timerGameOverMAX = 1.5

function love.load()
	love.graphics.setBackgroundColor(255,255,255)

	-- load leaderboard
	loadLeaderboard()

	-- load img
	loadImg()
	loadSound()

	cursor = love.mouse.newCursor( CROSSHAIR_IMG, CROSSHAIR_IMG:getWidth()/2,CROSSHAIR_IMG:getHeight()/2 )
	love.mouse.setCursor( cursor )

	if GAME_STATE == "PLAY" then
		-- Set initial camera location
		camera:setBounds(-100, 100, screenWidth+100,screenHeight+100)
		restartGame()
	elseif GAME_STATE == "TEST" then
		test_astart()
	end


end
radius = 120

function love.draw()

	if GAME_STATE == "PLAY" then
	-- Set camera position

		love.graphics.setBackgroundColor( 74,48,57 )

		camera:set(0,0)

		love.graphics.draw(BG_IMG,0,0,0,3,3)--BG_IMG:getWidth(),  BG_IMG:getHeight())

		-- praying zone
		-- love.graphics.setColor(222,10,40)
		-- love.graphics.circle("fill",shrine.pos.x,shrine.pos.y+60,150)
		-- love.graphics.setColor(255,255,255)

			-- DRAW ASTAR GRID
		if SHOW_GRID == true then
				love.graphics.setColor(242,233,227)
			for i,v in ipairs(handler.tiles) do
				local dist = math.sqrt(math.pow(radius,2)-math.pow((love.mouse.getY()+CAM_Y0-i*16*3),2))
				if dist <= radius then
					love.graphics.line(  love.mouse.getX() +CAM_X0 -  dist ,i*16*3, love.mouse.getX()+CAM_X0 + dist , i*16*3 )
				end

				for j,w in ipairs(v) do
					local 	dist = math.sqrt(math.pow(radius,2)-math.pow((love.mouse.getX()+CAM_X0-j*16*3),2))
					if dist <= radius then
						love.graphics.line( j*16*3,	love.mouse.getY() +CAM_Y0 -  dist, 		j*16*3,		love.mouse.getY() +CAM_Y0 +  dist)
					end
				end
			end
		end

		love.graphics.setColor(255,255,255)

	 	drawShrineBot()
		drawFXBot()
		drawCrates()
		drawItems()
		drawEnnemies()
	 	drawPlayer()
	 	drawShrineTop()
		drawMessages()
		drawFXTop()

		--love.graphics.setColor(0,0,0)
		--love.graphics.print("Score: "..score,30+2,110+2)
		--love.graphics.setColor(255,255,255)
		--love.graphics.print("Score: "..score,30,110)


		useCustomFont(50)
		love.graphics.setColor(0,0,0)
		love.graphics.print("Crates: "..player.crates_nbr,CAM_X0+30+2,CAM_Y0+30+2)
		if player.crates_nbr == 0 then
			love.graphics.setColor(255,25,1)
		else
			love.graphics.setColor(255,255,255)
		end
		love.graphics.print("Crates: "..player.crates_nbr,CAM_X0+30,CAM_Y0+30)


		if start_new_wave == true and start_new_wave_pressed == false and table.getn(ennemies) == 0 then

			useCustomFont(txt_size)
			love.graphics.setColor(9,33,22)
			love.graphics.printf("Press space to continue",screenWidth/3.25+4,screenHeight/1.8+4,500,'center')
			love.graphics.setColor(244,248,255)
			love.graphics.printf("Press space to continue",screenWidth/3.25,screenHeight/1.8,500,'center')
		end

		useDefaultFont()

		if debug then
			local offsetX = 10 --
			local offsetY = 100
			love.graphics.print("v_x: "..player.vit.x,100+offsetX,30+offsetY)
			love.graphics.print("v_y: "..player.vit.y, 100+offsetX,40+offsetY)

			love.graphics.print("a_x: "..player.acc.x,100+offsetX,60+offsetY)
			love.graphics.print("a_y: "..player.acc.y, 100+offsetX,70+offsetY)

			love.graphics.print("pos_x: "..player.pos.x,100+offsetX,90+offsetY)
			love.graphics.print("pos_y: "..player.pos.y, 100+offsetX,100+offsetY)

			love.graphics.print("player w: "..player.w,100+offsetX,110+offsetY)
			love.graphics.print("player h: "..player.h, 100+offsetX,120+offsetY)
			love.graphics.print("player canShoot: "..tostring(player.weapon.canShoot), 100+offsetX,130+offsetY)

			love.graphics.print("camera shake_type: "..camera.shaketype, 100+offsetX,140+offsetY)
			love.graphics.print("camera X: "..tostring(camera.x), 100+offsetX,150+offsetY)
			love.graphics.print("camera Y: "..tostring(camera.y), 100+offsetX,160+offsetY)
			love.graphics.print("camera shake Val: "..tostring(camera.shakeVal), 100+offsetX,170+offsetY)

			love.graphics.print("spawn1: "..tostring(pos_spawn[1]), 100+offsetX,190+offsetY)
			love.graphics.print("spawn2: "..tostring(pos_spawn[2]), 100+offsetX,200+offsetY)
			love.graphics.print("spawn3: "..tostring(pos_spawn[3]), 100+offsetX,210+offsetY)
			love.graphics.print("spawn4: "..tostring(pos_spawn[4]), 100+offsetX,220+offsetY)


			love.graphics.print("spawn1_eff: "..tostring(pos_spawn_eff[1]), 100+offsetX,230+offsetY)
			love.graphics.print("spawn2_eff: "..tostring(pos_spawn_eff[2]), 100+offsetX,240+offsetY)
			love.graphics.print("spawn3_eff: "..tostring(pos_spawn_eff[3]), 100+offsetX,250+offsetY)
			love.graphics.print("spawn_eff4: "..tostring(pos_spawn_eff[4]), 100+offsetX,260+offsetY)

			love.graphics.print("start_new_wave: "..tostring(start_new_wave), 100+offsetX,280+offsetY)

			love.graphics.print("Nbr anims: "..Nbr_anims, 100+offsetX,300+offsetY)

			love.graphics.print("CAM_X0: "..CAM_X0, 100+offsetX,310+offsetY)
			love.graphics.print("CAM_Y0: "..CAM_Y0, 100+offsetX,320+offsetY)

			love.graphics.print("screenWidth: "..(screenWidth-CAM_X0), 100+offsetX,330+offsetY)
			love.graphics.print("mouseX: "..tostring(love.mouse.getX()), 100+offsetX,340+offsetY)

			love.graphics.print("bullet_reload player: "..tostring(player.weapon.bullet_reload), 100+offsetX,360+offsetY)


			love.graphics.print("directory: "..tostring(love.filesystem.getSaveDirectory()), 100+offsetX,380+offsetY)


			--love.graphics.print("leaderboard: "..tostring(leaderboard[#leaderboard].score), 100+offsetX,380+offsetY)
			--if not(#leaderboard == 0) then
			love.graphics.print("leaderboard: "..tostring(leaderboard[#leaderboard].score), 100+offsetX,400+offsetY)
			--end


			love.graphics.print("LOSE: "..tostring(LOSE), 100+offsetX,420+offsetY)




		-- for i,v in ipairs(handler.tiles) do
			-- 	for j,w in ipairs(v) do
			-- 		if w == 0 then
			-- 			love.graphics.setColor(255,255,255)
			-- 			love.graphics.circle("fill",(j-0.5)*16*3,(i-0.5)*16*3,5)
			-- 		elseif w == 1 then
			-- 			love.graphics.setColor(0,0,0)
			-- 			love.graphics.circle("fill",(j-0.5)*16*3,(i-0.5)*16*3,5)
			-- 		end
			-- 	end
			-- end
		-- for i,v in ipairs(path_test) do
		-- 	love.graphics.setColor(255,0,0)
		-- 	love.graphics.circle("fill",(v.location.x-0.5)*16*3,(v.location.y-0.5)*16*3,5)
		-- end
		-- love.graphics.setColor(0,0,0)

		end

	-- Pops the current coordinate transformation from the transformation stack. ( 0,0 is again the top-left coordinate)
	camera:unset()


	elseif GAME_STATE ==  "START_MENU" then

		love.graphics.setBackgroundColor( 242,233, 227 )

		MASK_ANIM:draw(screenWidth/2,screenHeight/2-225,0, 3, 3,55,0)

		useCustomFont(200)
		love.graphics.setColor(9,33,22)
		love.graphics.printf("Zealots",screenWidth/2-500+10,screenHeight/2-400+10,1000,'center')
		useCustomFont(60)
		love.graphics.printf("Press space to start",screenWidth/2-760+4,screenHeight/2+350+3,1500,'center')

		love.graphics.setColor(74,48,57)
		useCustomFont(200)
		love.graphics.printf("Zealots",screenWidth/2-500,screenHeight/2-400,1000,'center')
		useCustomFont(60)
		love.graphics.printf("Press space to start",screenWidth/2-760,screenHeight/2+350,1500,'center')


		useCustomFont(40)
		local offsetX = -175
		local offsetY = 100
		love.graphics.setColor(9,33,22)
		love.graphics.printf("WASD to move",offsetX+screenWidth/2+4,offsetY+screenHeight/2+3,1500,'center')
		love.graphics.printf("Left click to shoot",offsetX+screenWidth/2+4,offsetY+screenHeight/2+50+3,1500,'center')
		love.graphics.printf("Right click to place crate",offsetX+screenWidth/2+4,offsetY+screenHeight/2+100+3,1500,'center')
		love.graphics.setColor(244,248,255 	)
		love.graphics.printf("WASD to move",offsetX+screenWidth/2+4,offsetY+screenHeight/2+3,1500,'center')
		love.graphics.printf("Left click to shoot",offsetX+screenWidth/2+4,offsetY+screenHeight/2+50+3,1500,'center')
		love.graphics.printf("Right click to place crate",offsetX+screenWidth/2+4,offsetY+screenHeight/2+100+3,1500,'center')

		love.graphics.setColor(0,0,0)
 		love.graphics.draw(MENU_TILE_IMG,0,21, 0, 3, 3, 0,0)
 		love.graphics.draw(MENU_TILE_IMG,0,screenHeight-7*3-21, 0, 3, 3, 0,0)

		useDefaultFont()

	elseif GAME_STATE ==  "LOSE" then

		--love.graphics.draw(BG_IMG,CAM_X0/2,CAM_Y0/2,0,3,3)
		MASK_ANIM:draw(screenWidth/2+400,screenHeight/2-300,0, 3, 3,55,0)

	 	drawShrineBot()
	 	drawShrineTop()

		useCustomFont(40)
		local offsetX = -775
		local offsetY = 200
		love.graphics.setColor(9,33,22)
		love.graphics.printf("You Lost Miserably",offsetX+screenWidth/2+4,offsetY+screenHeight/2+3,1500,'center')
		love.graphics.printf("Press space to restart",offsetX+screenWidth/2+4,offsetY+screenHeight/2+50+3,1500,'center')
		love.graphics.setColor(244,248,255 	)
		love.graphics.printf("You Lost Miserably",offsetX+screenWidth/2+4,offsetY+screenHeight/2,1500,'center')
		love.graphics.printf("Press space to restart",offsetX+screenWidth/2,offsetY+screenHeight/2+50,1500,'center')


		local offsetX = 0
		local offsetY = 0
		useCustomFont(120)
		love.graphics.setColor(9,33,22)
		love.graphics.printf("SCORE:  "..score,offsetX+screenWidth/2+4,offsetY+3,1500,'center')
		love.graphics.setColor(244,48,55 	)
		love.graphics.printf("SCORE:  "..score,offsetX+screenWidth/2,offsetY,1500,'center')

		useDefaultFont()
		love.graphics.setColor(0,0,0)

	elseif GAME_STATE ==  "TEST" then


	end

		love.graphics.setColor(255,255,255)
		love.graphics.print("FPS: "..tostring(love.timer.getFPS())	,30+2,20+2)
	love.graphics.setColor(255,255,255)
end

function test_astart()

handler:updatemap(crates)
--astar:initialize(handler)
local astar = AStar(handler)

end


function love.update(dt)
	-- if dt < 1/60 then
	-- 	love.timer.sleep(1/60 - dt)
	-- end

	time = time+5*dt
	if time > 2*math.pi then
		time = 0
	end

	if LOSE == false then
		timerGameOver = love.timer.getTime()
	end
	if LOSE == true and (love.timer.getTime() - timerGameOver > timerGameOverMAX) then
		GAME_STATE = "LOSE"
		LOSE = false
	end

	txt_size = 40 + 10*math.sin(time)
	if GAME_STATE == "PLAY" then
		updateShrine(dt)
		updatePlayer(dt)
		updateCrates(dt)
		updateItems(dt)
		updateEnnemies(dt)
		updateWave(dt)
		updateMessages(dt)
		updateFX(dt)

		camera:update(dt)
		--camera:setPosition( player.pos.x , player.pos.y )
	elseif GAME_STATE == "START_MENU" or GAME_STATE == "LOSE" then
		MASK_ANIM:update(dt)
	end
end
function restartGame()
	GAME_STATE = "PLAY"

    if not(score == 0) then
	    saveScore()
    end

	graph = {} -- Graph of available walking area nodes for A*
	path_test = {}

	handler = TiledMapHandler()
	astar = AStar(handler)
	handler:initialize() -- reset a* node graph

	wave = 0
	score = 0

	-- Player
	player = {
			pos = {x = I_max*TILE_W/2-200, y = J_max*TILE_H/2}, -- position
			vit = {x = 0, y = 0}, -- vitesse,
			acc = {x = 0, y = 0}, -- acceleration,

			direction = -1, -- "1=right", "-1=left"

			bullets = {},
			weapon= {
				timerAutoShoot = love.timer.getTime(),
				canShoot = false,
				bullet_reload = 0.3,
				nbr_bullet = 1
			},
			crates_nbr = 8,

			anim_idle = PLAYER_idle,
			anim_walk = PLAYER_walk,
			w = 3*12,
			h = 3*22,
			hitbox_w= 3*9,
			hitbox_h=3*16,

			dead = false,

			timerStartDust = love.timer.getTime(),
			DELAY_POP_DUST = 0.06,
			popdust = true

		}

	-- Ennemies
	ennemies = {}

	-- Items
	items = {}

	-- Crates
	crates = {}

	-- Anims
	anims = {}

	shrine = {
			pos = {x = SHRINE_POS.x*TILE_W, y = SHRINE_POS.y*TILE_W}, -- position
			w = 3*46,
			h = 3*78,
			hitbox_pos = {x = SHRINE_POS.x*TILE_W, y = SHRINE_POS.y*TILE_W+68},
			hitbox_w= 3*48,
			hitbox_h= 3*16,
			anim_top = SHRINE_TOP_ANIM,
			anim_bot = SHRINE_BOT_ANIM,
			loaded = 0	, -- load max = 1
			being_prayed = false
	}
	local SFX = love.audio.newSource("assets/sounds/game_on.wav", "static")
	SFX:setVolume(2)
	SFX:play()

end
