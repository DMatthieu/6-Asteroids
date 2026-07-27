--game.lua:

local SceneManager = require("src.core.scene_manager")
local Constants = require("src.constants")
local AsteroidField = require("src/entities/asteroid_field")
local Ship = require("src/entities/ship")
local Projectile = require("src/entities/projectile")
local Timer = require("src/core/timer")

local GameScene = {}

local ship
local asteroidField
local shipSprite = love.graphics.newImage("src/assets/gfx/ship.png")
local projectiles
local projectileSprite = love.graphics.newImage("src/assets/gfx/shot3.png")
local explosionSound = love.audio.newSource("src/assets/sfx/Explosion6.wav", "static")
local shipExplosionSound = love.audio.newSource("src/assets/sfx/Explosion5.wav", "static")
local lives
local gameWon


local function checkCircleCollision(a, radiusA, b, radiusB)
    local dx = a.x - b.x
    local dy = a.y - b.y

    local distance = math.sqrt(dx * dx + dy * dy)

    return distance <= radiusA + radiusB
end

local function createShip()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    return Ship.create(
        width / 2,
        height / 2,
        shipSprite,
        Constants.SHIP_THRUST_POWER,
        Constants.SHIP_ROTATION_SPEED
    )
end

function GameScene.enter()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    gameWon = false

    ship = createShip()

    asteroidField = AsteroidField.create(3)

    projectiles = {}

    lives = 3
end

function GameScene.update(dt)
    Timer.update(dt)

    if not ship.isDestroyed then
        ship:update(dt)
    end
   
    asteroidField:update(dt)

    --boucle d'update des projectiles
    for _, projectile in ipairs(projectiles) do
        projectile:update(dt)
    end

    -- Détection des collisions entre projectiles et astéroïdes
    for i = #projectiles, 1, -1 do
        local projectile = projectiles[i]

        local projectileRadius = math.min(
            projectile.sprite:getWidth(),
            projectile.sprite:getHeight()
        ) / 2

        for j = #asteroidField.asteroids, 1, -1 do
            local asteroid = asteroidField.asteroids[j]

            if checkCircleCollision(
                projectile,
                projectileRadius,
                asteroid,
                asteroid.radius
            ) then
                table.remove(projectiles, i)
                asteroidField:destroyAsteroid(j)
                explosionSound:clone():play()
                break
            end
        end
    end

    -- Détection des collisions entre le vaisseau et les astéroïdes
    if not ship.isDestroyed and not ship.isInvincible then
        for j = #asteroidField.asteroids, 1, -1 do
            local asteroid = asteroidField.asteroids[j]

            if checkCircleCollision(
                ship,
                ship.collisionRadius,
                asteroid,
                asteroid.radius
            ) then
                asteroidField:destroyAsteroid(j)
                ship:destroy()
                shipExplosionSound:clone():play()
                lives= lives - 1

                if lives > 0 then
                    Timer.after(2, function()
                        ship = createShip()
                        ship.isInvincible = true

                        Timer.after(2, function()
                            ship.isInvincible = false
                        end)
                    end)
                end

                break
            end
        end
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

    if lives > 0 and #asteroidField.asteroids == 0 then
        gameWon = true
    end
end

function GameScene.draw()
    ship:draw()
    asteroidField:draw()

    --boucle de draw des projectiles
    for _, projectile in ipairs(projectiles) do
        projectile:draw()
    end

    love.graphics.print("Lives: "..lives, 10, 90)

    if lives <= 0 then
        love.graphics.printf(
            "GAME OVER",
            0,
            love.graphics.getHeight() / 2,
            love.graphics.getWidth(),
            "center"
        )
    end



    if lives <= 0 then
    love.graphics.printf(
        "GAME OVER\nPress ENTER to restart",
        0,
        love.graphics.getHeight() / 2,
        love.graphics.getWidth(),
        "center"
    )
    elseif gameWon then
        love.graphics.printf(
            "YOU WIN!\nPress ENTER to restart",
            0,
            love.graphics.getHeight() / 2,
            love.graphics.getWidth(),
            "center"
        )
    end
end

function GameScene.keypressed(key)
    if key == "space" and lives > 0 and not ship.isDestroyed then
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

    if key == "return" and (lives <= 0 or gameWon) then
        SceneManager.setScene("game")
    end
end

return GameScene