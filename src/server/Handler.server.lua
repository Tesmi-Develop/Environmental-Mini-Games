local PlayerService = game:GetService("Players")
local Compoments = game.ServerScriptService.Core.Components
local DataHandler = require(Compoments.DataHandler)
local SpawnCoin = require(Compoments.SpawnCoin)

local function GetPlayerData(Player)
    local Data = {}
    for i, DataVariable in pairs(Player.leaderstats:GetChildren()) do
        table.insert(Data,1,DataVariable.Value)
    end
    task.wait()
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

    local Exp = Instance.new("NumberValue",PlayerData)
    local MaxExp = Instance.new("NumberValue",PlayerData)

    local MatchesWon = Instance.new("NumberValue",leaderstats)
    local HoursPlayed = Instance.new("NumberValue",PlayerData)

    leaderstats.Name = "leaderstats"
    PlayerData.Name = "PlayerData"
    Money.Name = "Money"
    Level.Name = "Level"
    Exp.Name = "Exp"
    MaxExp.Name = "MaxExp"
    MatchesWon.Name = "MatchesWon"
    HoursPlayed.Name = "HoursPlayed"
    task.wait()

    if Level.Value == 0 then
        Level.Value = 1
        MaxExp.Value = Level.Value * 100
    end

    DataHandler.LoadData(Player, leaderstats:GetChildren())
    DataHandler.LoadData(Player, PlayerData:GetChildren())

    task.wait()
    Level.Changed:Connect(function(NewLevel)
        MaxExp.Value = NewLevel * 100
    end)
end

PlayerService.PlayerAdded:Connect(function(Player)
    CreateLeaderstats(Player)
end)

PlayerService.PlayerRemoving:Connect(function(Player)
    local leaderstats = Player:WaitForChild("leaderstats")
    local PlayerData = Player:WaitForChild("PlayerData")

    local DataToSave = {}
    for _, Data in pairs(leaderstats:GetChildren()) do
         DataToSave[Data.Name] = Data.Value
    end
    for _, Data in pairs(PlayerData:GetChildren()) do
        DataToSave[Data.Name] = Data.Value
   end

    DataHandler.SaveData(Player, DataToSave)
end)

local ObbyCoinSpots = game.Workspace:WaitForChild("ObbyCoinSpawns")

local ExistingCoins = Instance.new("Folder",workspace)
ExistingCoins.Name = "ExistingCoins"

local function CoinSpawnManagement()
    local CoinsSpawnPoints = {}
    for _, CoinSpawn in pairs(ObbyCoinSpots:GetChildren()) do
        table.insert(CoinsSpawnPoints,CoinSpawn)
    end
    for _, ExistingC in pairs(ExistingCoins:GetChildren()) do
        ExistingC:Destroy()
    end
    task.wait()
    for i = 1, 4 do
        local RandomizeSpawn = math.random(1, #CoinsSpawnPoints)
        SpawnCoin.CreateCoinAt(CoinsSpawnPoints[RandomizeSpawn].CFrame,ExistingCoins)
        table.remove(CoinsSpawnPoints, RandomizeSpawn)
        task.wait()
    end
end

task.wait()

CoinSpawnManagement()
while task.wait(60) do
    CoinSpawnManagement()
end