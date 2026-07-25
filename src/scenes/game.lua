--game.lua:

local Constants = require("src.constants")
local AsteroidField = require("src/entities/asteroid_field")
local Ship = require("src/entities/ship")

local GameScene = {}

local ship
local asteroidField
local shipSprite = love.graphics.newImage("src/assets/gfx/ship.png")


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
end

function GameScene.update(dt)
    ship:update(dt)
    asteroidField:update(dt)
end

function GameScene.draw()
    ship:draw()
    asteroidField:draw()
end

function GameScene.keypressed(key)
    -- ship:keypressed(key)
end

return GameScene