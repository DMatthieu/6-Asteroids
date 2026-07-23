--ship.lua
local Ship = {}

function Ship.create(x, y, thrustPower, sprite)
    local ship = {}
    ship.x = x
    ship.y = y
    ship.dx = 0
    ship.dy = 0
    ship.angle = 0
    ship.thrustPower = thrustPower
    ship.thrusterActive = false
    ship.sprite = sprite

    function ship:draw()
        love.graphics.draw(
            self.sprite,
            self.x,
            self.y,
            self.angle,
            1,
            1,
            self.sprite:getWidth() / 2,
            self.sprite:getHeight() / 2
        )
    end

    return ship
end

return Ship