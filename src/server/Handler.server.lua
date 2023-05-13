local PlayerService = game:GetService("Players")
local Compoments = game.ServerScriptService.Core.Components
local DataHandler = require(Compoments.DataHandler)

local function GetPlayerData(Player)
    local Data = {}
    for i, DataVariable in pairs(Player.leaderstats:GetChildren()) do
        table.insert(Data,1,DataVariable.Value)
    end
    wait()
    for i, DataVariable in pairs(Player.PlayerData:GetChildren()) do
        table.insert(Data,1,DataVariable.Value)
    end
    return Data
end

local function CreateLeaderstats(Player)
    local leaderstats = Instance.new("Folder",Player)
    local PlayerData = Instance.new("Folder",Player)

    local Money = Instance.new("NumberValue",leaderstats)
    local Level = Instance.new("NumberValue",leaderstats)
    local Exp = Instance.new("NumberValue",leaderstats)
    local MatchesWon = Instance.new("NumberValue",leaderstats)
    local HoursPlayed = Instance.new("NumberValue",PlayerData)

    leaderstats.Name = "leaderstats"
    PlayerData.Name = "PlayerData"
    Money.Name = "Money"
    Level.Name = "Level"
    Exp.Name = "Exp"
    MatchesWon.Name = "MatchesWon"
    HoursPlayed.Name = "HoursPlayed"
end

PlayerService.PlayerAdded:Connection(function(Player)
    CreateLeaderstats(Player)
end)

while wait(60) do
    for _, Player in pairs(game.Players:GetChildren()) do
        local Data = GetPlayerData(Player)

    end
end