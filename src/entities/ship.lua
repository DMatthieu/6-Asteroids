--ship.lua
local Ship = {}

function Ship.create(x, y, sprite, thrustPower, rotationSpeed)
    local ship = {}
    ship.x = x
    ship.y = y
    ship.dx = 0
    ship.dy = 0
    ship.angle = 0
    ship.thrustPower = thrustPower
    ship.thrusterActive = false
    ship.sprite = sprite
    ship.rotationSpeed = rotationSpeed
   
    function ship:update(dt)
        if love.keyboard.isDown('left') then
            self.angle = self.angle - self.rotationSpeed * dt
        end 
        if love.keyboard.isDown('right') then
            self.angle = self.angle + self.rotationSpeed * dt
        end

        local angleInRadians = math.rad(self.angle)

        local directionX = math.sin(angleInRadians)
        local directionY = -math.cos(angleInRadians)

        self.thrusterActive = love.keyboard.isDown("up")

        if self.thrusterActive then
            self.dx = self.dx + directionX * self.thrustPower * dt
            self.dy = self.dy + directionY * self.thrustPower * dt
        end

        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt

        local halfWidth = self.sprite:getWidth() / 2
        local halfHeight = self.sprite:getHeight() / 2
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()
        
        if self.x < -halfWidth then
            self.x = screenWidth + halfWidth
        elseif self.x > screenWidth + halfWidth then
            self.x = -halfWidth
        end

        if self.y < -halfHeight then
            self.y = screenHeight + halfHeight
        elseif self.y > screenHeight + halfHeight then
            self.y = -halfHeight
        end

    end

    function ship:draw()
        love.graphics.draw(
            self.sprite,
            self.x,
            self.y,
            math.rad(self.angle),
            1,
            1,
            self.sprite:getWidth() / 2,
            self.sprite:getHeight() / 2
        )

        love.graphics.print("ship X: "..self.x, 10, 10)
        love.graphics.print("ship Y: "..self.y, 10, 30)

    end

    function ship:shoot()
        
    end

    return ship
end

return Ship