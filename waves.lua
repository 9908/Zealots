start_new_wave = true
TIME_START_WAVE = 3 				-- Time between message display and ennemy spawn

timerStartWaves = love.timer.getTime() 	


function updateWave(dt) -- Update the wave system

	if love.timer.getTime() - timerStartWaves > TIME_START_WAVE and start_new_wave == false then
		SummonEnnemies(1000,195,wave*5+1) -- POP NEW WAVE WHEN MESSAGE FINISHED DISPLAY
		wave = wave + 1
		start_new_wave = true
	end

	if table.getn(ennemies) == 0 and start_new_wave then
		addBigMessage("Wave no."..(wave+1),40)
		newItem()
		start_new_wave = false
		timerStartWaves = love.timer.getTime() 

	end

end
