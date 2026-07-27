--game.lua:

local Constants = require("src.constants")
local AsteroidField = require("src/entities/asteroid_field")
local Ship = require("src/entities/ship")
local Projectile = require("src/entities/projectile")

local GameScene = {}

local ship
local asteroidField
local shipSprite = love.graphics.newImage("src/assets/gfx/ship.png")
local projectiles
local projectileSprite = love.graphics.newImage("src/assets/gfx/shot3.png")


function GameScene.enter()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    ship = Ship.create(
        width / 2,
        height / 2,
        shipSprite,
        Constants.SHIP_THRUST_POWER,
        Constants.SHIP_ROTATION_SPEED    
    )

    asteroidField = AsteroidField.create(8)

    projectiles = {}
end

function GameScene.update(dt)
    ship:update(dt)
    asteroidField:update(dt)

    --boucle d'update des projectiles
    for _, projectile in ipairs(projectiles) do
        projectile:update(dt)
    end

    --Suppression des projectiles entièrement hors écran
    for i = #projectiles, 1, -1 do
        local projectile = projectiles[i]

        local halfWidth = projectile.sprite:getWidth() / 2
        local halfHeight = projectile.sprite:getHeight() / 2
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()

        local isOutside =
            projectile.x < -halfWidth
            or projectile.x > screenWidth + halfWidth
            or projectile.y < -halfHeight
            or projectile.y > screenHeight + halfHeight

        if isOutside then
            table.remove(projectiles, i)
        end
    end
end

function GameScene.draw()
    ship:draw()
    asteroidField:draw()

    --boucle de draw des projectiles
    for _, projectile in ipairs(projectiles) do
        projectile:draw()
    end
    love.graphics.print("Nb Projectiles: "..#projectiles, 10, 70)
end

function GameScene.keypressed(key)
    if key == 'space' then
        local shotData = ship:shoot()

        local projectile = Projectile.create(
            shotData.x,
            shotData.y,
            shotData.dx,
            shotData.dy,
            Constants.PROJECTILE_SPEED,
            projectileSprite
        )

        table.insert(projectiles, projectile)
    end
end

return GameScene