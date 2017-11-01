function drawItems()
	 for i,v in ipairs(items) do  -- Draw ceates
    	--love.graphics.rectangle("fill",v.pos.x-v.w/2,v.pos.y-v.h/2,v.w,v.h)


 		love.graphics.draw(ITEM_SHADOW_IMG,v.pos.x-v.w/2+4,v.pos.y-4, 0, 3, 3, 0,0)
 		v.anim:draw( v.pos.x-v.w/2,v.pos.y-v.h/2, 0, 3, 3, 0,0)
	end
end

function updateItems(dt)
	for i,v in ipairs(items) do  -- pick up item
    	if distance(v.pos.x,v.pos.y,player.pos.x,player.pos.y) < 35 then
    		player.crates_nbr = player.crates_nbr + 8

    		pop_pickup_anim(v.pos.x-15,v.pos.y-15)
    		pickup_item_SFX:play()
    		
    		table.remove(items,i)
    	end

    	v.anim:update(dt)
	end
end

function newItem()
	-- body
	local rdm = math.random(3)
	local local_x = 1
	local local_y = 1

	if rdm == 1 then
		local_x = 485
		local_y = 770
	elseif rdm == 2 then
		local_x = 1420
		local_y = 387
	elseif rdm == 3 then
		local_x = 78
		local_y = 55
	end

	ITEM_ANIM = newAnimation(love.graphics.newImage("assets/item.png"), 16, 20, 0.2, 0)
	ITEM_ANIM:setMode("loop")

	table.insert(items, {
		anim=ITEM_ANIM,
		w=3*16,
		h=3*20,
		pos={x=local_x, y=local_y}}
	)
end