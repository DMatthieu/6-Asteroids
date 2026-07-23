--game.lua:

local Constants = require("src.constants")
local Ship = require("src/entities/ship")

local GameScene = {}

local ship
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
end

function GameScene.update(dt)
   ship:update(dt)
end

function GameScene.draw()
    ship:draw()
end

function GameScene.keypressed(key)
    -- ship:keypressed(key)
end

return GameScene