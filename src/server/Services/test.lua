local car = {}
car.__index = car

function car.new()
    local self = setmetatable({}, car)

    return self
end

return car