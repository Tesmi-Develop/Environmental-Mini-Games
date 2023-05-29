local DataStore = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local PlayerData = DataStore:GetOrderedDataStore("PlayerDataStore")
local Leaderboard = game.Workspace:WaitForChild("Leaderboards")

local ReplicatedStorage = game.ReplicatedStorage
local Components = require(ReplicatedStorage.Packages.Components)
local Signal = require(ReplicatedStorage.Packages.Signal)

local LeaderboardItems = game.ServerStorage.LeaderboardItems

local LeaderboardComponent = Components.new({
    Tag = "Leaderboard"
})

function LeaderboardComponent:Construct()
    self.LoadTime = 120;
    self.LoadStats = {"Money","MatchesWon","HoursPlayed"}
end

function LeaderboardComponent:CreateTemplate(Index,PlayerName, Value)

    local Clone = LeaderboardItems.Template:Clone()
    Clone.Parent = self.Instance:FindFirstChildOfClass("SurfaceGui").List
    
    Clone.Rank.Text = tostring(Index)
    Clone.StatName.Text = tostring(Value)
    Clone.User.Text = PlayerName
end

function LeaderboardComponent:Start()
    local instance = self.Instance
    local success, ErrorMsg = pcall(function()
        local data = PlayerData:GetSortedAsync(false, 100)
        local Page = data:GetCurrentPage()
        for Index, dataStored in pairs(Page) do
            if dataStored.Name == instance.Name then
                local PlayerName = Players:GetNameFromUserIdAsync(tonumber(dataStored.key))
                local Stats = dataStored.Value
                LeaderboardComponent:CreateTemplate(Index,PlayerName,Stats)
            end
        end
    end)
end

function LeaderboardComponent:Stop()
    if self.Connection then
        self.Connection:Disconnect()
    end
end

return LeaderboardComponent