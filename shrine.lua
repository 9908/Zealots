token = 1
nbr = 0
function drawShrineBot()

	
	--love.graphics.setColor(246,250,240)
	--love.graphics.rectangle("fill",shrine.hitbox_pos.x-shrine.hitbox_w/2,shrine.hitbox_pos.y-shrine.hitbox_h/2,shrine.hitbox_w,shrine.hitbox_h)

	if shrine.loaded > 1 then
		love.graphics.setColor(242,233,227)
	else
		love.graphics.setColor(210,73,95)
	end
	love.graphics.arc( "line",shrine.pos.x+7,shrine.pos.y+77,50*3,-3*math.pi/2,-3*math.pi/2+math.pi*2*shrine.loaded)
	love.graphics.setColor(255,255,255)

	-- Shrine
	love.graphics.draw(SHRINE_SHADOW_IMG,shrine.pos.x-3*(92/2), shrine.pos.y-3*(112/2), 0, 3, 3,0,0)
	
	if shrine.being_prayed == false then
		love.graphics.draw(SHRINE_BOT_IMG, shrine.pos.x-shrine.w/2, shrine.pos.y-shrine.h/2,0, 3, 3,0,0)
	else
		shrine.anim_bot:draw( shrine.pos.x-shrine.w/2, shrine.pos.y-shrine.h/2,0, 3, 3,0,0)
	end

end

function drawShrineTop()
	
	if shrine.being_prayed == false then
		love.graphics.draw(SHRINE_TOP_IMG, shrine.pos.x-shrine.w/2, shrine.pos.y-shrine.h/2,0, 3, 3,0,0)
	else
		shrine.anim_top:draw( shrine.pos.x-shrine.w/2, shrine.pos.y-shrine.h/2,0, 3, 3,0,0)
	end
		
	for i = 1,shrine.popped do 
		if i == shrine.popped then
			love.graphics.draw(SHRINE_COMPLETE_IMG[i],shrine.pos.x-3*576/2+30,shrine.pos.y-320*2-20,0,3,4)
		end
	end
end

function updateShrine(dt)
	
	-- ANIM
	shrine.anim_top:update(dt)
	shrine.anim_bot:update(dt)

	if shrine.being_prayed == true then 	
		shrine.loaded = shrine.loaded + 0.1*dt
		if shrine.loaded >= ((nbr)*1/8)  then
			token = token + 1
			nbr = nbr + 1
		end
	end
	if shrine.loaded > 1.2 then
		if shrine.canPop  then
			shrine.canPop = false
			shrine.timerPopping = love.timer.getTime()
			shrine.popped = shrine.popped + 1
			if (shrine.popped % 2 == 0) then FX_whiteflicker() end
			camera.shakedir = math.random(360)*2*math.pi/360
			camera.shaketype = "shooting"
			--SummonEnnemies(v.pos.x,v.pos.y,1,{ID=3,posx=v.pos.x, posy=v.pos.y}) 
		end
		if love.timer.getTime() - shrine.timerPopping > shrine.DELAY_POPPING and shrine.canPop == false then
			shrine.canPop = true
		end

		if shrine.popped > 12 then
			shrine.isPopping = false
			shrine.popped = 0
			shrine.loaded = 0
			GAME_STATE = "LOSE"
		end					
	end
end