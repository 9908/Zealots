function drawShrineBot()

	
	--love.graphics.setColor(246,250,240)
	--love.graphics.rectangle("fill",shrine.hitbox_pos.x-shrine.hitbox_w/2,shrine.hitbox_pos.y-shrine.hitbox_h/2,shrine.hitbox_w,shrine.hitbox_h)

	love.graphics.setColor(255,255,255)
	-- Shrine
	love.graphics.draw(SHRINE_SHADOW_IMG,shrine.pos.x-3*(92/2), shrine.pos.y-3*(112/2), 0, 3, 3,0,0)
	if shrine.being_prayed == false then
		love.graphics.draw(SHRINE_BOT_IMG, shrine.pos.x-shrine.w/2, shrine.pos.y-shrine.h/2,0, 3, 3,0,0)
	else
		shrine.anim_bot:draw( shrine.pos.x-shrine.w/2, shrine.pos.y-shrine.h/2,0, 3, 3,0,0)
	end

	-- Loading bar
	love.graphics.setColor(246,250,240)
	love.graphics.rectangle("fill",shrine.pos.x-100,shrine.pos.y-140,200,20)
	love.graphics.setColor(247,25,4)
	love.graphics.rectangle("fill",shrine.pos.x-95,shrine.pos.y-135,shrine.loaded*180,10)
	love.graphics.setColor(255,255,255)
end

function drawShrineTop()
	
	if shrine.being_prayed == false then
		love.graphics.draw(SHRINE_TOP_IMG, shrine.pos.x-shrine.w/2, shrine.pos.y-shrine.h/2,0, 3, 3,0,0)
	else
		shrine.anim_top:draw( shrine.pos.x-shrine.w/2, shrine.pos.y-shrine.h/2,0, 3, 3,0,0)
	end
		
end

function updateShrine(dt)
	
	-- ANIM
	shrine.anim_top:update(dt)
	shrine.anim_bot:update(dt)

	if shrine.being_prayed == true then 	
		shrine.loaded = shrine.loaded + 0.1*dt
	end
	if shrine.loaded > 1 then
		GAME_STATE = "LOSE"
	end
end