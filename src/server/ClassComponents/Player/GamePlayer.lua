local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Stats = require(script.Parent.Stats)
local Leaderstats = require(script.Parent.Leaderstats)
local Signal  = require(ReplicatedStorage.Packages.Signal)
local DataHandler = require(ServerScriptService.Core.ComponentsHandler)['DataHandler']

local GamePlayer = {}
GamePlayer.__index = GamePlayer
GamePlayer.list = {}

function GamePlayer.StaticInit()
    Players.PlayerAdded:Connect(function(player)
        GamePlayer.new(player):Init()
    end)

    Players.PlayerRemoving:Connect(function(player)
        GamePlayer.RemovePlayer(player)
    end)
end

function GamePlayer.FindPlayer(player: Player)
    return GamePlayer.list[player]
end

function GamePlayer.RemovePlayer(player: Player)
    GamePlayer.list[player] = nil
end

function GamePlayer.new(instance: Player)
    local self = setmetatable({}, GamePlayer)
    self.Instance = instance
    self.Stats = Stats.new(self)
    self.Leaderstats = Leaderstats.new(self)
    self.OnSaveData = Signal.new()
    self.Data = nil

    return self
end

function GamePlayer:LoadData()
    self.Data = DataHandler.GetProfile(self.Instance, Stats.DataName , {}).Data
end

function GamePlayer:GetData(name: string, defaultData: table)
    if self.Data[name] == nil then
        self.Data[name] = defaultData
    end

    return self.Data[name]
end

function GamePlayer:SetData(name: string, data: any)
    self.Data[name] = data
end

function GamePlayer:Init()
    GamePlayer.list[self.Instance] = self

    self:LoadData()
    self.Stats:Init()
    self.Leaderstats:Init()

    DataHandler.OnSaveData:Connect(function(player)
        if player == self.Instance then
            self.OnSaveData:Fire()
        end
    end)
end

return GamePlayer
