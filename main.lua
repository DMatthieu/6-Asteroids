local SceneManager = require("src.core.scene_manager")
local GameScene = require("src.scenes.game")

function love.load()
    SceneManager.registerScenes({
        game = GameScene
    })

    SceneManager.setScene('game')
end

function love.update(dt)
    SceneManager.update(dt)
end

function love.draw()
    SceneManager.draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    SceneManager.keypressed(key)
end