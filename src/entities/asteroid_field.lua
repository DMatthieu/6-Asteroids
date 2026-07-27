--asteroid_field.lua

local Constants = require("src.constants")
local Asteroid = require("src.entities.asteroid")

local AsteroidField = {}

function AsteroidField.create(count)
    local field = {}
        field.asteroids = {}
    

    for i= 1, count do
        local angle = love.math.random() * math.pi * 2
        local radius = love.math.random(Constants.ASTEROID_MINIMUM_RADIUS, Constants.ASTEROID_MAXIMUM_RADIUS)
        local x = love.math.random(radius, love.graphics.getWidth() - radius)
        local y = love.math.random(radius, love.graphics.getHeight() - radius)
        local dx = math.cos(angle)
        local dy = math.sin(angle)
        local vertexCount = Constants.ASTEROID_VERTEX_COUNT
        local speed = love.math.random(
            Constants.ASTEROID_MINIMUM_SPEED,
            Constants.ASTEROID_MAXIMUM_SPEED
        )


        local asteroid = Asteroid.create(x, y, dx, dy, speed, radius, vertexCount )
        table.insert(field.asteroids, asteroid)
        print("Asteroid N°"..#field.asteroids.." inserted.")
    end

    function field:update(dt)
        for _, asteroid in ipairs(field.asteroids) do
            asteroid:update(dt)

            --Screen wrapping asteroids
            if asteroid.x + asteroid.radius < 0 then
                asteroid.x = love.graphics.getWidth() + asteroid.radius
            elseif asteroid.x - asteroid.radius > love.graphics.getWidth() then
                asteroid.x = -asteroid.radius
            end

            if asteroid.y + asteroid.radius < 0 then
                asteroid.y = love.graphics.getHeight() + asteroid.radius
            elseif asteroid.y - asteroid.radius > love.graphics.getHeight() then
                asteroid.y = -asteroid.radius
            end
        end
    end

    function field:draw()
        for _, asteroid in ipairs(field.asteroids) do
            asteroid:draw()
        end
    end

    function field:destroyAsteroid(index)
        local asteroid = self.asteroids[index]
        local fragmentRadius = asteroid.radius / 2

        if fragmentRadius >= Constants.ASTEROID_MINIMUM_RADIUS then
            for i = 1, 2 do
                local angle = love.math.random() * math.pi * 2
                local dx = math.cos(angle)
                local dy = math.sin(angle)

                local newAsteroid = Asteroid.create(
                    asteroid.x,
                    asteroid.y,
                    dx,
                    dy,
                    asteroid.speed,
                    fragmentRadius,
                    Constants.ASTEROID_VERTEX_COUNT
                )

                table.insert(self.asteroids, newAsteroid)
            end
        end

        table.remove(self.asteroids, index)
    end

    return field
end



return AsteroidField