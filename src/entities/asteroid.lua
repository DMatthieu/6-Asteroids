local Asteroid = {}

local function generateShape(radius, vertexCount)
    -- créer le tableau
    local points = {}

    --
    local angleStep = 360 / vertexCount

    for i = 0, vertexCount - 1 do
        local angle = math.rad(i * angleStep)

        local pointRadius = love.math.random(radius * 0.8, radius * 1.2)

        --
        local x = pointRadius * math.cos(angle)
        local y = pointRadius * math.sin(angle)

        table.insert(points, x)
        table.insert(points, y)
    end

    return points
end

function Asteroid.create(x, y, dx, dy, speed, radius, vertexCount)
    local asteroid = {}
    

    asteroid.x = x
    asteroid.y = y
    asteroid.dx = dx
    asteroid.dy = dy
    asteroid.points = generateShape(radius, vertexCount)
    asteroid.speed = speed

    function asteroid:update(dt)
        --mouvements
        self.x = self.x + self.dx * self.speed * dt
        self.y = self.y + self.dy * self.speed * dt
    end

    function asteroid:draw()
        local drawPoints = {}

        for i = 1, #self.points, 2 do
            drawPoints[i] = self.points[i] + self.x 
            drawPoints[i + 1] = self.points[i + 1] + self.y 
        end

        love.graphics.polygon("line", drawPoints)
    end


    return asteroid
end

return Asteroid