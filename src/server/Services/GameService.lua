local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Components = require(ServerScriptService.Core.ComponentsHandler)

local DataHandler = Components['DataHandler'];
local GamePlayer = Components['GamePlayer'];

local GameService = Knit.CreateService({
    Name = "GameService",
    Client = {}
})

function GameService:KnitInit()
    DataHandler.Init()
    GamePlayer.StaticInit()
end

return GameService