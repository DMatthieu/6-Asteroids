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

        -- love.graphics.print("Rotational Direction: "..ship.rotationalDirection, 10, 10)
    end

    -- function ship:keypressed(key)

    -- end

    return ship
end

return Ship