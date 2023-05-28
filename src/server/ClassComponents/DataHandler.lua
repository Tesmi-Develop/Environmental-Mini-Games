local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.Core.Libraries.ProfileService)
local Signal = require(ReplicatedStorage.Packages.Signal)
local DataHandler = {}

DataHandler.OnLoadData = Signal.new()
DataHandler.OnSaveData = Signal.new()
DataHandler.Profiles = {}
DataHandler.ProfileStore = ProfileService.GetProfileStore('PlayerDataStore', {})

function DataHandler.GetProfile(player: Player)
    if DataHandler.Profiles[player] == nil then
        DataHandler.WaitProfilePlayer(player)
    end

    return DataHandler.Profiles[player]
end

function DataHandler.PlayerAdded(player: Player)
    local profile = DataHandler.ProfileStore:LoadProfileAsync(tostring(player.UserId))

    if profile == nil then
        player:Kick('Problem with dataStore')
        return
    end

    profile:AddUserId(player.UserId)
    profile:ListenToRelease(function()
        DataHandler.Profiles[player] = nil
        player:Kick('Problem with dataStore')
    end)

    if player:IsDescendantOf(Players) then
        DataHandler.Profiles[player] = profile
        DataHandler.OnLoadData:Fire(player)
        return
    end

    profile:Release()
end

function DataHandler.WaitProfilePlayer(myPlayer: Player)
    local isFinish = false;

    if DataHandler.Profiles[myPlayer] ~= nil then return end

    local connection
    connection = DataHandler.OnLoadData:Connect(function(player)
        if myPlayer ~= player then return end

        isFinish = true;
        connection:Disconnect()
    end)

    while not isFinish do
        task.wait()
    end
end

function DataHandler.SaveData(player: Player)
    local profile = DataHandler.GetProfile(player)

    if profile == nil then return end

    DataHandler.OnSaveData:Fire(player)
    task.wait()
    profile:Release()
end

function DataHandler.SetData(player: Player, name: string, data: table)
    local profile = DataHandler.GetProfile(player)

    if profile == nil then return end

    profile.Data[name] = data
end

function DataHandler.GetData(player: Player, name: string, defaultData: table)
    local profile = DataHandler.GetProfile(player)

    if profile == nil then return end

    if profile.Data[name] == nil then
        DataHandler.SetData(player, name, defaultData)
    end

    return profile.Data[name]
end

function DataHandler.Init()
    Players.PlayerAdded:Connect(DataHandler.PlayerAdded)
    Players.PlayerRemoving:Connect(DataHandler.SaveData)

    for i, player in Players:GetPlayers() do
        task.spawn(DataHandler.PlayerAdded, player)
    end
end

return DataHandler