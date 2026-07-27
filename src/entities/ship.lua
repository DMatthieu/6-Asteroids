--ship.lua
local Ship = {}

function Ship.create(x, y, sprite, thrustPower, rotationSpeed)
    local ship = {}
    ship.x = x
    ship.y = y
    ship.dx = 0
    ship.dy = 0
    ship.directionX = 0
    ship.directionY = -1
    ship.angle = 0
    ship.thrustPower = thrustPower
    ship.thrusterActive = false
    ship.sprite = sprite
    ship.rotationSpeed = rotationSpeed
    ship.collisionRadius = math.min(
        sprite:getWidth(),
        sprite:getHeight()
    ) * 0.35
    ship.isDestroyed = false
    ship.isInvincible = false
    ship.blinkTimer = 0
   
    function ship:update(dt)

        if self.isInvincible then
            self.blinkTimer = self.blinkTimer + dt
        else
            self.blinkTimer = 0
        end 

        --Rotation du vaisseau
        if love.keyboard.isDown('left') then
            self.angle = self.angle - self.rotationSpeed * dt
        end 
        if love.keyboard.isDown('right') then
            self.angle = self.angle + self.rotationSpeed * dt
        end

        -- Modification de la direction de la vitesse
        local angleInRadians = math.rad(self.angle)
        self.directionX = math.sin(angleInRadians)
        self.directionY = -math.cos(angleInRadians)

        -- Détection de l'activation du reacteur et application de la direction sur la vitesse
        self.thrusterActive = love.keyboard.isDown("up")
        if self.thrusterActive then
            self.dx = self.dx + self.directionX * self.thrustPower * dt
            self.dy = self.dy + self.directionY * self.thrustPower * dt
        end

        --Affectation de la vitesse résiduelle aux coordonnées du vaisseau
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt

        --Screen wrapping
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

        if self.isDestroyed then
            return
        end

        if self.isInvincible and math.floor(self.blinkTimer * 8) % 2 == 0 then
            return
        end
        
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
        return {
            x = self.x,
            y = self.y,
            dx = self.directionX,
            dy = self.directionY
        }
    end

    function ship:destroy()
        print("ship destroyed")
        self.isDestroyed = true
        self.dx = 0
        self.dy = 0
        self.thrusterActive = false
    end

    return ship
end

return Ship