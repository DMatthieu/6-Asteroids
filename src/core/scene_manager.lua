local SceneManager = {}

local scenes = {}
local currentScene

function SceneManager.register(name, scene)
    scenes[name] = scene
end

function SceneManager.registerScenes(sceneCollection)
    for name, scene in pairs(sceneCollection) do
        SceneManager.register(name, scene)
    end
end

function SceneManager.setScene(name)
    local scene = scenes[name]

    if not scene then
        error(("SceneManager: unknown scene '%s'"):format(name))
    end

    if currentScene and currentScene.leave then
        currentScene.leave()
    end

    currentScene = scene

    if currentScene.enter then
        currentScene.enter()
    end
end

function SceneManager.update(dt)
    if currentScene and currentScene.update then
        currentScene.update(dt)
    end
end

function SceneManager.draw()
    if currentScene and currentScene.draw then
        currentScene.draw()
    end
end

function SceneManager.keypressed(key)
    if currentScene and currentScene.keypressed then
        currentScene.keypressed(key)
    end
end

return SceneManager