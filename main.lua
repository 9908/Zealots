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


debug =  false

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
score_mult = 1
score_timer = love.timer.getTime()
score_timerMax = 2 

wave = 0 							-- Current wave numbering

time = 0
txt_size = 60 + 20*math.sin(time)

SHRINE_POS = {x = (I_max-1)/2 , y=(J_max-1)/2 }

LOSE = false
timerGameOver = love.timer.getTime()
timerGameOverMAX = 1.5

torches = {
	1,
	0,
	0,
	0,
	0,
	0,
	0,
	0
}

function love.load()
	love.graphics.setBackgroundColor(255,255,255)
	--resetLeaderboard()
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
		drawTorches()
	 	drawPlayer()
	 	drawShrineTop()
		drawMessages()
		drawFXTop()

		local offsetX = screenWidth+CAM_X0*2.3
		love.graphics.draw(UI_IMG,CAM_X0+5+offsetX,CAM_Y0+12,0,3,3)--BG_IMG:getWidth(),  BG_IMG:getHeight())
		--love.graphics.setColor(0,0,0)
		--love.graphics.print("Score: "..score,30+2,110+2)
		--love.graphics.setColor(255,255,255)
		--love.graphics.print("Score: "..score,30,110)


		useCustomFont(50)

		love.graphics.setColor(0,0,0)
		love.graphics.print("= "..player.stack+1,CAM_X0+120+2+offsetX,CAM_Y0+15+2)
		love.graphics.print("= "..player.crates_nbr,CAM_X0+120+2+offsetX,CAM_Y0+80+2)
		love.graphics.print("Score = "..score,CAM_X0+5+offsetX-30,CAM_Y0+80+95+5)
		useCustomFont(35)
		love.graphics.print("x"..score_mult,CAM_X0+120+5+offsetX-30,CAM_Y0+155+5)
		useCustomFont(50)
		
		if player.stack == 0 then
			love.graphics.setColor(255,25,1)
		else
			love.graphics.setColor(255,255,255)
		end
		love.graphics.print("= "..player.stack+1,CAM_X0+120+offsetX,CAM_Y0+15)
		
		if player.crates_nbr == 0 then
			love.graphics.setColor(255,25,1)
		else
			love.graphics.setColor(255,255,255)
		end
		love.graphics.print("= "..player.crates_nbr,CAM_X0+120+offsetX,CAM_Y0+80)

		if score_mult == 1 then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(213,162,111)
		end
		useCustomFont(35)
		love.graphics.print("x"..score_mult,CAM_X0+120+offsetX-30,CAM_Y0+155)
		useCustomFont(50)

		love.graphics.setColor(210,73,95)
		local rect_w = 200+100*(score_timer-love.timer.getTime())
		if (rect_w > 0 ) then
			love.graphics.rectangle("fill",CAM_X0+2+offsetX,CAM_Y0+145+2,rect_w,16)
		end

		love.graphics.setColor(255,255,255)
		love.graphics.print("Score = "..score,CAM_X0+offsetX-30,CAM_Y0+80+95)



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


			love.graphics.print("score: "..score, 100+offsetX,460+offsetY)
			--if not(#leaderboard == 0) then
			--love.graphics.print("leaderboard: "..tostring(leaderboard[#leaderboard].score), 100+offsetX,400+offsetY)
			--end


			love.graphics.print("LOSE: "..tostring(LOSE), 100+offsetX,420+offsetY)


			love.graphics.print("player.stack: "..tostring(player.stack), 100+offsetX,440+offsetY)
			love.graphics.print("wave: "..tostring(wave), 100+offsetX,480+offsetY)
			love.graphics.print("WEN: "..tostring(WEN[1][2].ID), 100+offsetX,490+offsetY)




			for i,v in ipairs(handler.tiles) do
				for j,w in ipairs(v) do
					if w == 0 then
						love.graphics.setColor(255,255,255)
						love.graphics.circle("fill",(j-0.5)*16*3,(i-0.5)*16*3,5)
					elseif w == 1 then
						love.graphics.setColor(0,0,0)
						love.graphics.circle("fill",(j-0.5)*16*3,(i-0.5)*16*3,5)
					end
				end
			end
			for i,v in ipairs(path_test) do
				love.graphics.setColor(255,0,0)
				love.graphics.circle("fill",(v.location.x-0.5)*16*3,(v.location.y-0.5)*16*3,5)
			end
			love.graphics.setColor(0,0,0)


			love.graphics.setColor(0,0,0)
			love.graphics.circle("fill",love.mouse.getX() + CAM_X0,love.mouse.getY() + CAM_Y0,5)

		end

	-- Pops the current coordinate transformation from the transformation stack. ( 0,0 is again the top-left coordinate)
	camera:unset()


	elseif GAME_STATE ==  "START_MENU" then

		love.graphics.setBackgroundColor( 242,233, 227 )

		MASK_ANIM:draw(screenWidth/2-400,screenHeight/2-275,0, 3, 3,55,0)

		KEYS_ANIM:draw(screenWidth/2+385,screenHeight/3,0, 3, 3,55,0)
		MOUSE_LEFT_ANIM:draw(screenWidth/2+450,screenHeight/3+170,0, 3, 3,55,0)
		MOUSE_RIGHT_ANIM:draw(screenWidth/2+450,screenHeight/3+320,0, 3, 3,55,0)

		useCustomFont(200)
		love.graphics.setColor(9,33,22)
		love.graphics.printf("Zealots",screenWidth/2-500+8,screenHeight/2-500+6,1000,'center')
		useCustomFont(100)
		love.graphics.printf("Press space to start",screenWidth/2-760+2,screenHeight/2+370+1,1500,'center')

		love.graphics.setColor(74,48,57)
		useCustomFont(200)
		love.graphics.printf("Zealots",screenWidth/2-500,screenHeight/2-500,1000,'center')
		love.graphics.rectangle("fill",screenWidth/2-250-70,screenHeight/2-300+0,660,16)
		useCustomFont(100)
		love.graphics.printf("Press space to start",screenWidth/2-760,screenHeight/2+370,1500,'center')

		love.graphics.setColor(9,33,22)
		love.graphics.printf("MOVE",screenWidth/2-50+2,screenHeight/3+1,1500,'left')
		love.graphics.printf("SHOOT",screenWidth/2-50+2,screenHeight/3+150+1,1500,'left')
		love.graphics.printf("CRATE",screenWidth/2-50+2,screenHeight/3+300+1,1500,'left')
		love.graphics.setColor(74,48,57)
		love.graphics.printf("MOVE",screenWidth/2-50,screenHeight/3,1500,'left')
		love.graphics.printf("SHOOT",screenWidth/2-50,screenHeight/3+150,1500,'left')
		love.graphics.printf("CRATE",screenWidth/2-50,screenHeight/3+300,1500,'left')

		--love.graphics.setColor(0,0,0)
 		--love.graphics.draw(MENU_TILE_IMG,0,21, 0, 3, 3, 0,0)
 		--love.graphics.draw(MENU_TILE_IMG,0,screenHeight-7*3-21, 0, 3, 3, 0,0)
		love.graphics.rectangle("fill", CAM_X0, CAM_Y0,screenWidth-CAM_X0*2, 120)
		love.graphics.rectangle("fill", CAM_X0, CAM_Y0+screenHeight,screenWidth-CAM_X0*2, CAM_Y0*2+screenHeight)

		useDefaultFont()

	elseif GAME_STATE ==  "LOSE" then
		love.graphics.setBackgroundColor(74,48,57)

		--love.graphics.draw(BG_IMG,CAM_X0/2,CAM_Y0/2,0,3,3)
		MASK_ANIM:draw(screenWidth/2+500,screenHeight/2-300,0, 3, 3,55,0)

	 	--drawShrineBot()
	 	--drawShrineTop()

		useCustomFont(80)
		local offsetX = -775
		local offsetY = 200
		love.graphics.setColor(9,33,22)
		love.graphics.printf("You Lost Miserably",offsetX+screenWidth/2+6,offsetY+screenHeight/2+4,1500,'center')
		love.graphics.printf("Press space to restart",offsetX+screenWidth/2+6,offsetY+screenHeight/2+50+4,1500,'center')
		love.graphics.setColor( 242,233, 227 )
		love.graphics.printf("You Lost Miserably",offsetX+screenWidth/2,offsetY+screenHeight/2,1500,'center')
		love.graphics.printf("Press space to restart",offsetX+screenWidth/2,offsetY+screenHeight/2+50,1500,'center')


		local offsetX = 600
		local offsetY = 0
		useCustomFont(140)
		love.graphics.setColor(9,33,22)
		love.graphics.printf("SCORE:  "..score,screenWidth/2-CAM_X0-offsetX+8,-CAM_Y0+6,1000,'center')
		love.graphics.setColor( 210,73, 95 )
		love.graphics.printf("SCORE:  "..score,screenWidth/2-CAM_X0-offsetX,-CAM_Y0,1000,'center')

		-- leaderboard
		useCustomFont(80)
		local offsetX = 1100
		local offsetY = 150
		love.graphics.setColor(9,33,22)
		love.graphics.printf("LEADERBOARD",screenWidth/2-CAM_X0-offsetX+6,-CAM_Y0+offsetY+4,1500,'center')
		love.graphics.printf("Date",screenWidth/2-CAM_X0-offsetX-200+6,-CAM_Y0+offsetY+120+4,1500,'center')
		love.graphics.printf("Score",screenWidth/2-CAM_X0-offsetX+200+4,-CAM_Y0+offsetY+120+4,1500,'center')
		love.graphics.setColor( 242,233, 227 )
		love.graphics.printf("LEADERBOARD",screenWidth/2-CAM_X0-offsetX,-CAM_Y0+offsetY,1500,'center')
		love.graphics.rectangle("fill", screenWidth/2-CAM_X0-offsetX+550, -CAM_Y0+offsetY+100,400, 8)
		love.graphics.printf("Date",screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+120,1500,'center')
		love.graphics.printf("Score",screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+120,1500,'center')
		love.graphics.rectangle("fill", screenWidth/2-CAM_X0-offsetX+350, -CAM_Y0+offsetY+200,800, 4)

		useCustomFont(60)
		if #leaderboard >= 5 then
			love.graphics.printf(leaderboard[#leaderboard].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+220,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+220,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-1].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+260,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-1].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+260,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-2].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+300,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-2].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+300,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-3].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+340,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-3].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+340,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-3].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+380,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-3].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+380,1500,'center')
		elseif #leaderboard == 4 then
			love.graphics.printf(leaderboard[#leaderboard].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+220,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+220,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-1].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+260,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-1].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+260,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-2].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+300,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-2].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+300,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-3].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+340,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-3].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+340,1500,'center')
		elseif #leaderboard == 3 then
			love.graphics.printf(leaderboard[#leaderboard].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+220,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+220,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-1].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+260,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-1].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+260,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-2].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+300,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-2].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+300,1500,'center')
		elseif #leaderboard == 2 then
			love.graphics.printf(leaderboard[#leaderboard].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+220,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+220,1500,'center')

			love.graphics.printf(leaderboard[#leaderboard-1].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+260,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard-1].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+260,1500,'center')
		elseif #leaderboard == 1 then
			love.graphics.printf(leaderboard[#leaderboard].date,screenWidth/2-CAM_X0-offsetX-200,-CAM_Y0+offsetY+220,1500,'center')
			love.graphics.printf(leaderboard[#leaderboard].score,screenWidth/2-CAM_X0-offsetX+200,-CAM_Y0+offsetY+220,1500,'center')
		end
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

	if love.timer.getTime()-score_timer < score_timerMax then
		score_mult = 1.5
	else
		score_mult = 1
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
		KEYS_ANIM:update(dt)
		MOUSE_LEFT_ANIM:update(dt)
		MOUSE_RIGHT_ANIM:update(dt)
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
			popdust = true,

			stack = 0

		}

	-- Ennemies
	ennemies = {}

	-- Items
	items = {}

	-- Crates
	crates = {}

	-- Anims
	anims = {}

	WAVE = {wave_going_on = false,
			timerPopEnnemy = love.timer.getTime(),
			timerPopMax = 2,
			ennemy_popped = 0,
			current_batch = {},
			current_batch_ID_in_table = 1
	}

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
			being_prayed = false,
			canPop = false,
			timerPopping =love.timer.getTime(),
			popped = 0,
			DELAY_POPPING = 0.1
	}
	local SFX = love.audio.newSource("assets/sounds/game_on.wav", "static")
	SFX:setVolume(2)
	SFX:play()

end
