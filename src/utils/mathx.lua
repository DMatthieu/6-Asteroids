local MathX = {}

    function MathX.clamp(value, minimum, maximum)
        if minimum > maximum then
            error("MathX.clamp: minimum must be less than or equal to maximum.")
        end
        return math.max(
                minimum,
                math.min(
                    value,
                    maximum
                )
            )
    end

return MathX