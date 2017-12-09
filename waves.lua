start_new_wave = true
TIME_START_WAVE = 5 				-- Time between message display and ennemy spawn

timerStartWaves = love.timer.getTime()
pos_spawn = {} -- contains all directions of spawn rolled (always 4)
pos_spawn_eff = {} -- contains all directions of effective spawn 
display_arrow = false
function updateWave(dt) -- Update the wave system (left edge - 1) then rotate clockwise

	if love.timer.getTime() - timerStartWaves > TIME_START_WAVE then
		if start_new_wave == false then -- START NEW WAVE

			display_arrow = false

			wave = wave + 1
			start_new_wave = true
		end
	end

	if table.getn(ennemies) == 0 and start_new_wave == true then -- WAVE FINISHED
		addBigMessage("Wave no."..(wave+1),40,pos_spawn)
		newCrateSupply()
		start_new_wave = false
		timerStartWaves = love.timer.getTime()
		display_arrow = true

		pos_spawn = {}	
		for i = 1,4 do 
			local random_Dir = love.math.random(4) -- pick une direction de spawn au hasard
			table.insert(pos_spawn, random_Dir)
		end

		SummonEnnemies(1000,195,wave*5+1) -- POP NEW WAVE WHEN MESSAGE FINISHED DISPLAY

	end

end
