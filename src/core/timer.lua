--------------------------------------------------
-- Timer.lua
--
-- Framework LÖVE2D
--
-- Gère l'exécution différée d'actions.
--
-- API publique :
--
-- Timer.after()
-- Timer.update()
-- Timer.cancel()
--------------------------------------------------
local Timer = {}

local timers = {}

    function Timer.after(duration, callback) 
        local timer = {
            duration = duration,
            elapsed = 0,
            callback = callback
        }
        table.insert(timers, timer)

        return timer
    end

    function Timer.update(dt)
        for index = #timers, 1, -1 do
            local timer = timers[index]
            timer.elapsed = timer.elapsed + dt
            if (timer.elapsed >= timer.duration) then
                table.remove(timers, index)
                timer.callback()
            end
        end
    end

    function Timer.cancel(reference)
        for index = #timers, 1, -1 do
            local timer = timers[index]

            if (timer == reference) then
                table.remove(timers, index)
                return true
            end
        end
        return false
    end

return Timer