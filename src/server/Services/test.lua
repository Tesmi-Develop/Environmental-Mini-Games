local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local test = Knit.CreateService({
    Name = "test",
    Client = {}
})

return test