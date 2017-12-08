CAM_X0 = (36*16*3 - love.graphics.getWidth())/2
CAM_Y0 = (20*16*3 - love.graphics.getHeight())/2
camera = {}
camera.x = CAM_X0
camera.y = CAM_Y0
camera.sx = 1
camera.sy = 1
camera.rotation = 0
camera.speed = 50
camera.directionX = "left"
camera.directionY = "none"
camera.shiftX = 0
camera.shiftY = 0
camera.shakeX = 0
camera.shakeY = 0
camera.shakedir = 0
camera.shakeVal = 0
camera.shiftmax = 70
camera.shake = false
camera.shaketype = "none"


function camera:set(pX,pY)
  love.graphics.push()

  love.graphics.translate(pX, pY)
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.sx, 1 / self.sy)
  love.graphics.translate(-pX, -pY)

  love.graphics.translate(-self.x, -self.y)
end


function camera:update( dt )
  if not(camera.shaketype == "none") then
    camera.shake = true
  end

  if camera.shake then
    camera.shakeVal = camera.shakeVal + 30*dt

    if camera.shaketype == "explosion" then
      if camera.shakeVal > 2*math.pi then
        camera.shakeX = math.cos(camera.shakedir)*5*math.sin(camera.shakeVal)
        camera.shakeY = math.sin(camera.shakedir)*5*math.sin(camera.shakeVal)
      else
        camera.shakeX = math.cos(camera.shakedir)*10*math.sin(camera.shakeVal)
        camera.shakeY = math.sin(camera.shakedir)*10*math.sin(camera.shakeVal)
      end
      if camera.shakeVal > 4*math.pi then
        camera.shake = false
        camera.x = CAM_X0
        camera.y = CAM_Y0
        camera.shakeX = 0
        camera.shakeY = 0
        camera.shakeVal = 0
        camera.shaketype = "none"
      end

    elseif camera.shaketype == "shooting" then
      if camera.shakeVal > 2*math.pi then
        camera.shakeX = math.cos(camera.shakedir)*2*math.sin(camera.shakeVal)
        camera.shakeY = math.sin(camera.shakedir)*2*math.sin(camera.shakeVal)
      else
        camera.shakeX = math.cos(camera.shakedir)*3.3*math.sin(camera.shakeVal)
        camera.shakeY = math.sin(camera.shakedir)*3.3*math.sin(camera.shakeVal)
      end
      if camera.shakeVal > 4*math.pi then
        camera.shake = false
        camera.x = CAM_X0
        camera.y = CAM_Y0
        camera.shakeX = 0
        camera.shakeY = 0
        camera.shakeVal = 0
        camera.shaketype = "none"
      end
    end
    camera.x = camera.x + camera.shakeX
    camera.y = camera.y + camera.shakeY
    
  end
end
function camera:unset()
  love.graphics.pop()
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:scale(sx, sy)
  sx = sx or 1
  sy = sy or 1
  self.sx = self.sx * sx
  self.sy = self.sy * sy
end

function camera:reset()
	self.sx = 0.5
	self.sy = 0.5
	self.rotation = 0
end

function camera:setX(value)
  local mapWidth = screenWidth*self.sx
  local posScreenX = X0

  if self._bounds then
    self.x = math.clamp(posScreenX + self.shakeX , self._bounds.x1, self._bounds.x2)
  else
    self.x = posScreenX
  end
end

function camera:setY(value)
  local mapHeight = screenHeight*self.sy
  local posScreenY = Y0
  if self._bounds then
    self.y = math.clamp(posScreenY + self.shakeY , self._bounds.y1, self._bounds.y2)
  else
    self.y = posScreenY
  end
end

function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end

end

function camera:getPosition()
	return self.x, self.y
end

function camera:setScale(sx, sy)
  self.sx = sx or self.sx
  self.sy = sy or self.sy
end

function camera:getScaleX()
  return self.sx 
end

function camera:getBounds()
  return unpack(self._bounds)
end

function camera:setBounds(x1, y1, x2, y2)
  self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end