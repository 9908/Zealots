-- Diplay message on screen

messages = {}

function useCustomFont(size)
	font = love.graphics.newFont("assets/Minusio.ttf", size)
	love.graphics.setFont(font)
end

function useDefaultFont()
	love.graphics.setFont(love.graphics.newFont(12))
end

function updateMessages( dt )
	for i, msg in ipairs(messages) do

		if msg.toremove == true then
			if msg.opacity > 0 then
				msg.opacity = msg.opacity - msg.fadeawayspeed*dt
			else
				table.remove(messages, i)

			end
		else
			if msg.opacity < msg.maxopacity then -- Max opacity reached
				msg.opacity = msg.opacity + msg.fadeawayspeed*dt
			else
				if love.timer.getTime() - msg.timerStart >= msg.timetodisplay then -- stop displaying
					msg.toremove = true
				end
			end
		end
	end
end

function addBigMessage(textmsg, sizemsg)
	table.insert(messages,
		{
			text = textmsg,
			opacity = 0,
			fadeawayspeed = 250,
			timetodisplay = 3,
			timerStart = love.timer.getTime(), -- Starts too soon ?
			size = sizemsg,
			toremove = false,
			maxopacity = 225,
			posx = 0.985*J_max*TILE_H,
			posy = I_max*TILE_W,
			type = "wave",
			color = {242, 233, 227, 255}
		}
	)
end

function addAttackMessage(textmsg, sizemsg)
	table.insert(messages,
		{
			text = textmsg,
			opacity = 150,
			fadeawayspeed = 250,
			timetodisplay = 3,
			timerStart = love.timer.getTime(), -- Starts too soon ?
			size = sizemsg,
			toremove = false,
			maxopacity = 225,
			posx = 0.985*J_max*TILE_H,
			posy = I_max*TILE_W,
			type = "attack",
			color = {242, 233, 227, 255}
		}
	)
end

function addCrateMessage(textmsg, sizemsg)
	table.insert(messages,
		{
			text = textmsg,
			opacity = 250,
			fadeawayspeed = 250,
			timetodisplay = 5,
			timerStart = love.timer.getTime(), -- Starts too soon ?
			size = sizemsg,
			toremove = false,
			maxopacity = 225,
			posx = CAM_X0+5+screenWidth+CAM_X0*2.3,
			posy = CAM_Y0+280,
			type = "crate",
			color = {242, 233, 227, 255}
		}
	)
end

function addShieldMessage(textmsg, sizemsg)
	table.insert(messages,
		{
			text = textmsg,
			opacity = 250,
			fadeawayspeed = 250,
			timetodisplay = 5,
			timerStart = love.timer.getTime(), -- Starts too soon ?
			size = sizemsg,
			toremove = false,
			maxopacity = 225,
			posx = CAM_X0+5+screenWidth+CAM_X0*2.3,
			posy = CAM_Y0+120,
			type = "shield",
			color = {242, 233, 227, 255}
		}
	)
end

function drawMessages()
	useCustomFont(50)
	for i, msg in ipairs(messages) do
		--myColor = {155, 155, 70,msg.opacity}
		if msg.type == "wave" then
			love.graphics.setColor(52,58,71)
			local msg_H = 0.1*J_max*TILE_H
			love.graphics.rectangle("fill", CAM_X0, CAM_Y0,screenWidth, (msg.opacity/msg.maxopacity*msg_H))
			love.graphics.rectangle("fill", CAM_X0, CAM_Y0+(1-(msg.opacity/msg.maxopacity))*msg_H+0.9*screenHeight, screenWidth, -CAM_Y0+(1-(-msg.opacity+msg.maxopacity)/msg.maxopacity)*msg_H)
		end
		--myColor = {255, 255, 255,255}
		love.graphics.setColor(msg.color)
		if msg.opacity > 0.9*msg.maxopacity then
			love.graphics.printf(msg.text, 0, msg.posx, msg.posy,"center")
		end
	end
end

function drawScore()
	love.graphics.print(score, 50 , 40)
end
