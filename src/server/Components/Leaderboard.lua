local DataStore = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local GamePlayer = require(ServerScriptService.Core.ComponentsHandler)['GamePlayer'];
local Components = require(ReplicatedStorage.Packages.Components)
local Template = game.ServerStorage.LeaderboardItems.Template

local LeaderboardComponent = Components.new({
    Tag = "Leaderboard"
})

function LeaderboardComponent:Construct()
    self.LoadTime = 60;
    self.IsStop = false;
    self.CountRanks = self.Instance:GetAttribute('CountRanks');
    self.StatsName = self.Instance:GetAttribute('Type');
    self.DataStore = DataStore:GetOrderedDataStore('Leaderboard'..self.StatsName);
    self.List = self.Instance:FindFirstChildOfClass("SurfaceGui").List;

    if self.CountRanks == nil then
        error('LeaderBoard '..self.Instance.Name..' not have attribute CountRanks')
    end
end

function LeaderboardComponent:CreateTemplate(index, playerName, value)

    local Clone = Template:Clone()
    Clone.Parent = self.List
    Clone.Visible = false;
    
    Clone.Rank.Text = '#'..tostring(index)
    Clone.StatName.Text = tostring(value)
    Clone.User.Text = playerName

    task.spawn(function()
        task.wait()
        Clone.Visible = true;
    end)
end

function LeaderboardComponent:Update()
    -- Write values in DataStore
    for i, player in GamePlayer.list do
        local playerId = player.Instance.UserId

        if playerId > 0 then
            local StatsValue = player.Stats:Find(self.StatsName);

            if StatsValue == nil then
                error('Not found stats by name '..self.StatsName)
            end

            self.DataStore:SetAsync(playerId, StatsValue:GetValue());
        end
    end

    local Frames = self.List:GetChildren()

    local success, ErrorMsg = pcall(function()
        local data = self.DataStore:GetSortedAsync(false, self.CountRanks)
        local Page = data:GetCurrentPage()

        for index, dataStored in ipairs(Page) do
            local userName = Players:GetNameFromUserIdAsync(dataStored.key);
            local Value = dataStored.value

            if Value then
                self:CreateTemplate(index, userName, Value)
            end
        end
    end);

    for index, value in Frames do
        if value:IsA(Template.ClassName) then
            value:Destroy()
        end
    end
end

function LeaderboardComponent:Start()
    self:Update();
    
    while not self.IsStop do
        task.wait(self.LoadTime)
        self:Update();
    end
end

function LeaderboardComponent:Stop()
    self.IsStop = true
end

return LeaderboardComponent