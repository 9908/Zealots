start_new_wave = true
TIME_START_WAVE = 5 				-- Time between message display and ennemy spawn

timerStartWaves = love.timer.getTime()
pos_spawn = {} -- contains all directions of spawn rolled (always 4)
pos_spawn_eff = {} -- contains all directions of effective spawn 
display_arrow = false

WEN = { -- ID = 0 to end wave
	{ -- WAVE 1
		{ID = 1, nbr = 5, freq = 1.5}, 
		{ID = 2, nbr = 5, freq = 1.5}, 
		{ID = 0, nbr = 1, freq = 1} -- MANDATORY END OF BATCH WITH ID = 0
	},

	{ -- WAVE 2
		{ID = 3, nbr = 5, freq = 1.5}, 
		{ID = 3, nbr = 5, freq = 1} , 
		{ID = 3, nbr = 5, freq = 0.5} , 
		{ID = 0, nbr = 1, freq = 1}-- MANDATORY END OF BATCH WITH ID = 0
	},

	{ -- WAVE 3
		{ID = 1, nbr = 5, freq = 1}, 
		{ID = 3, nbr = 20, freq = 0.3} , 
		{ID = 4, nbr = 3, freq = 1} , 
		{ID = 0, nbr = 1, freq = 1}-- MANDATORY END OF BATCH WITH ID = 0
	},

	{-- WAVE 4
		{ID = 1, nbr = 10, freq = 0.5}, 
		{ID = 2, nbr = 15, freq = 1} ,
		{ID = 1, nbr = 10, freq = 0.5}, 
		{ID = 5, nbr = 1, freq = 1} , 
		{ID = 1, nbr = 10, freq = 0.5},
		{ID = 0, nbr = 1, freq = 1}-- MANDATORY END OF BATCH WITH ID = 0
	},

	{ -- WAVE 5
		{ID = 3, nbr = 5, freq = 1.2}, 
		{ID = 3, nbr = 8, freq = 0.7} , 
		{ID = 1, nbr = 10, freq = 0.3},
		{ID = 3, nbr = 10, freq = 0.2} ,
		{ID = 1, nbr = 3, freq = 0.2},
		{ID = 0, nbr = 1, freq = 1}-- MANDATORY END OF BATCH WITH ID = 0
	},

	{ -- WAVE 6
		{ID = 1, nbr = 10, freq = 0.1},
		{ID = 5, nbr = 5, freq = 1} , 
		{ID = 2, nbr = 10, freq = 1.4} , 
	 	{ID = 4, nbr = 5, freq = 1},
		{ID = 0, nbr = 1, freq = 1}-- MANDATORY END OF BATCH WITH ID = 0
	},
	
	{ -- WAVE 7 LAST WAVE
		{ID = 1, nbr = 10, freq = 0.1},
		{ID = 3, nbr = 20, freq = 0.3} ,
		{ID = 1, nbr = 10, freq = 0.1}, 
		{ID = 2, nbr = 15, freq = 1.4} ,
		{ID = 1, nbr = 10, freq = 0.1}, 
		{ID = 5, nbr = 5, freq = 1},
		{ID = 1, nbr = 10, freq = 0.1},
		{ID = 3, nbr = 20, freq = 0.1},
		{ID = 4, nbr = 10, freq = 0.5},
		{ID = 0, nbr = 1, freq = 1}-- MANDATORY END OF BATCH WITH ID = 0
	}
}

WAVE = {wave_going_on = false,
		timerPopEnnemy = love.timer.getTime(),
		timerPopMax = 2,
		ennemy_popped = 0,
		current_batch = {},
		current_batch_ID_in_table = 1
}

function updateWave(dt) -- Update the wave system (left edge - 1) then rotate clockwise

	if love.timer.getTime() - timerStartWaves > TIME_START_WAVE then
		if start_new_wave == false then -- START NEW WAVE

			display_arrow = false

			wave = wave + 1
			start_new_wave = true
		end
	end

	if WAVE.wave_going_on then 
		update_current_popping(dt)
	else
		if table.getn(ennemies) == 0 and start_new_wave == true then -- WAVE FINISHED
			addBigMessage("Wave no."..(wave+1),40,pos_spawn)
			newCrateSupply()
			newPowerUp()
			start_new_wave = false
			timerStartWaves = love.timer.getTime()
			display_arrow = true

			pos_spawn = {}	
			for i = 1,4 do 
				local random_Dir = love.math.random(4) -- pick une direction de spawn au hasard
				table.insert(pos_spawn, random_Dir)

				if random_Dir == 1 then
					pop_arrow_anim(CAM_X0  		+ 57*3/2		,SHRINE_POS.y*TILE_H + 57*3/2,-math.pi/2) -- left
				elseif random_Dir== 2 then -- up edge
					pop_arrow_anim(SHRINE_POS.x*TILE_W 	- 36*3/2		,0 				,0) -- up		
				elseif random_Dir == 3 then -- right edge
					pop_arrow_anim(screenWidth - CAM_X0 - 3*57*3/2 ,SHRINE_POS.y*TILE_H  		,math.pi/2) -- right					
				elseif random_Dir == 4 then -- down edge
					pop_arrow_anim(SHRINE_POS.x*TILE_W	+ 36*3/2		,screenHeight-CAM_Y0 - 57*3	,math.pi) -- down
				end
			end

			StartPopEnnemies(wave)
		end
	end

	
end

function StartPopEnnemies(ID) -- Start a new wave of multiple batches
	WAVE.wave_going_on = true
	WAVE.timerPopEnnemy = love.timer.getTime()
	WAVE.current_batch_ID_in_table = 1	
	local wavv = WEN[#WEN]
	if wave < #WEN then
		wavv = WEN[wave+1]
	end
	WAVE.current_batch = wavv[1]
	WAVE.timerPopMax = WAVE.current_batch.freq
	WAVE.ennemy_popped = 0
end

function update_current_popping(dt)
	if WAVE.current_batch.ID == 0 then
		WAVE.wave_going_on = false
	else
		if love.timer.getTime() - WAVE.timerPopEnnemy > WAVE.timerPopMax then

			WAVE.timerPopEnnemy = love.timer.getTime()
			
			if wave > #WEN then
				if WAVE.ennemy_popped <= (WAVE.current_batch.nbr + WAVE.current_batch.nbr*(wave-#WEN)/4) then
					SummonEnnemies(1,WAVE.current_batch,false)
					WAVE.ennemy_popped = WAVE.ennemy_popped + 1
				else
					WAVE.current_batch_ID_in_table = WAVE.current_batch_ID_in_table + 1
					local id = WAVE.current_batch_ID_in_table
					WAVE.current_batch = WEN[#WEN][id]
					
					WAVE.timerPopMax = WAVE.current_batch.freq
					WAVE.ennemy_popped = 0	
				end
			else
				if WAVE.ennemy_popped <= WAVE.current_batch.nbr then
					SummonEnnemies(1,WAVE.current_batch,false)
					WAVE.ennemy_popped = WAVE.ennemy_popped + 1
				else
					WAVE.current_batch_ID_in_table = WAVE.current_batch_ID_in_table + 1
					local id = WAVE.current_batch_ID_in_table
					WAVE.current_batch = WEN[wave][id]
					
					WAVE.timerPopMax = WAVE.current_batch.freq
					WAVE.ennemy_popped = 0
				end
			end
		end
	end
end