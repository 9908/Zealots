require("utilities")
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

require ("astar")
require ("class")
require ("examplemaphandler")
require ("middleclass")
require ("profiler")
require ("tiledmaphandler")

require ("middleclass")
require ("middleclass")
require ("middleclass")

GAME_STATE = "START_MENU" -- START_MENU, PLAY - LOSE - WIN

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

score = 0

SHRINE_POS = {x = (I_max-1)/2 , y=(J_max-1)/2 }
function love.load()
	love.graphics.setBackgroundColor(100, 100, 100)
 

	-- load img
	loadImg()
	loadSound()

	if GAME_STATE == "PLAY" then
		-- Set initial camera location
		camera:setBounds(-100, 100, screenWidth+100,screenHeight+100)
		restartGame()
	elseif GAME_STATE == "TEST" then
		test_astart()
	end

end

function love.draw() 

	if GAME_STATE == "PLAY" then 
	-- Set camera position
		camera:set(0,0)

		love.graphics.draw(BG_IMG,0,0,0,3,3)--BG_IMG:getWidth(),  BG_IMG:getHeight())

		-- praying zone
		-- love.graphics.setColor(222,10,40)
		-- love.graphics.circle("fill",shrine.pos.x,shrine.pos.y+60,150)
		-- love.graphics.setColor(255,255,255)

		drawCrates()
	 	drawShrineBot()
		drawItems()
		drawEnnemies()
	 	drawPlayer()
	 	drawShrineTop()
		drawFX()
		drawMessages()

		love.graphics.setColor(0,0,0)
		love.graphics.print("Score: "..score,30+2,110+2)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Score: "..score,30,110)


		love.graphics.setColor(0,0,0)
		love.graphics.print("Boxes: "..player.crates_nbr,30+2,160+2)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Boxes: "..player.crates_nbr,30,160)
		
		useDefaultFont()

		-- local offsetX = 10 --
		-- local offsetY = 100
		-- 	love.graphics.print("v_x: "..player.vit.x,100+offsetX,30+offsetY)
		-- 	love.graphics.print("v_y: "..player.vit.y, 100+offsetX,40+offsetY)

		-- 	love.graphics.print("a_x: "..player.acc.x,100+offsetX,60+offsetY)
		-- 	love.graphics.print("a_y: "..player.acc.y, 100+offsetX,70+offsetY)

		-- 	love.graphics.print("pos_x: "..player.pos.x,100+offsetX,90+offsetY)
		-- 	love.graphics.print("pos_y: "..player.pos.y, 100+offsetX,100+offsetY)

		-- 	love.graphics.print("player w: "..player.w,100+offsetX,110+offsetY)
		-- 	love.graphics.print("player h: "..player.h, 100+offsetX,120+offsetY)

		-- 	love.graphics.print("camera shake_type: "..camera.shaketype, 100+offsetX,140+offsetY)
		-- 	love.graphics.print("camera X: "..tostring(camera.x), 100+offsetX,150+offsetY)
		-- 	love.graphics.print("camera Y: "..tostring(camera.y), 100+offsetX,160+offsetY)
		-- 	love.graphics.print("camera shake Val: "..tostring(camera.shakeVal), 100+offsetX,170+offsetY)

			--love.graphics.print("bullets_ennemy: "..tostring(table.getn(ennemies[1].bullets)), 100+offsetX,180+offsetY)


			-- DRAW ASTAR GRID
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


	-- Pops the current coordinate transformation from the transformation stack. ( 0,0 is again the top-left coordinate)
	camera:unset()
	

	elseif GAME_STATE ==  "START_MENU" then

		love.graphics.setBackgroundColor( 242,233, 227 )
		love.graphics.setBackgroundColor( 93,98,125 )

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

		love.graphics.setColor(0,0,0)
 		love.graphics.draw(MENU_TILE_IMG,0,21, 0, 3, 3, 0,0)
 		love.graphics.draw(MENU_TILE_IMG,0,screenHeight-7*3-21, 0, 3, 3, 0,0)

		useDefaultFont()

	elseif GAME_STATE ==  "LOSE" then

		love.graphics.draw(BG_IMG,0,0,0,3,3)
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
		

		local offsetX = -1050
		local offsetY = 200
		useCustomFont(120)
		love.graphics.setColor(9,33,22)
		love.graphics.printf("SCORE:  "..score,offsetX+screenWidth/2-200+4,offsetY+screenHeight/3-100+3,1500,'center')
		love.graphics.setColor(244,48,55 	)
		love.graphics.printf("SCORE:  "..score,offsetX+screenWidth/2-200,offsetY+screenHeight/3-100,1500,'center')

		useDefaultFont()
		love.graphics.setColor(0,0,0)

	elseif GAME_STATE ==  "TEST" then
		
		
	end

	love.graphics.setColor(255,255,255)
end

function test_astart()

handler:updatemap(crates)
--astar:initialize(handler) 
local astar = AStar(handler)

end


function love.update(dt)
	if dt < 1/60 then
		love.timer.sleep(1/60 - dt)
	end


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
			crates_nbr = 227,

			anim_idle = PLAYER_idle,
			anim_walk = PLAYER_walk,
			w = 3*12,
			h = 3*22,
			hitbox_w= 3*9,
			hitbox_h=3*16,

			dead = false,

			timerStart = love.timer.getTime()

		}

	-- Ennemies
	ennemies = {}

	-- Items
	items = {}
	newItem()

	-- Crates
	crates = {} 

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