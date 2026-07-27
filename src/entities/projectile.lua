--projectile.lua
local Projectile = {}

function Projectile.create(x, y, dx, dy, speed, sprite)
    local projectile = {}
    projectile.x = x
    projectile.y = y
    projectile.dx = dx
    projectile.dy = dy
    projectile.speed = speed
    projectile.sprite = sprite

    function projectile:update(dt)
        self.x = self.x + self.dx * self.speed * dt
        self.y = self.y + self.dy * self.speed * dt
    end

    function projectile:draw()
        love.graphics.draw(self.sprite, 
            self.x, 
            self.y,
            0,
            1,
            1,
            self.sprite:getWidth() / 2,
            self.sprite:getHeight() / 2
        )
    end    

    return projectile
end

return Projectile