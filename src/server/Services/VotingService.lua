local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)

local VotingService = Knit.CreateService({
    Name = "VotingService";
    ContentOnVoting = nil;
    ListVoted = {};
    Time = 0;
    OnEndVote = Signal.new();

    Client = {
        OnStartVoting = Knit.CreateSignal();
        OnUpdateCountVote = Knit.CreateSignal();
        OnChangeTime = Knit.CreateSignal();
        OnEndVote = Knit.CreateSignal();
    }
});

function VotingService.Client:Vote(player: Player, index: number)
    if (self.Server.ContentOnVoting == nil) then
        return false, 'You tried to vote when there was no voting'
    end

    if (#self.Server.ContentOnVoting < index) then
        return false, 'Unknown index'
    end

    local content = self.Server.ContentOnVoting[index]
    local lastContentIndex = self.Server.ListVoted[player]

    if lastContentIndex ~= nil then
        local oldContent = self.Server.ContentOnVoting[lastContentIndex]
        oldContent.CountVoting -= 1

        self.OnUpdateCountVote:FireAll(lastContentIndex, oldContent.CountVoting)
    end

    self.Server.ListVoted[player] = index
    content.CountVoting += 1
    self.OnUpdateCountVote:FireAll(index, content.CountVoting)

    return true, nil
end

function VotingService:GetWinningContent()
    assert(self.ContentOnVoting, 'There is no vote')

    local winningContent = {}
    local max = 0

    for i, value in self.ContentOnVoting do
        max = math.max(max, value.CountVoting)
    end

    for index, value in self.ContentOnVoting do
        if value.CountVoting == max then
            table.insert(winningContent, value)
        end
    end

    return winningContent[math.random(1, #winningContent)]
end

function VotingService:EndVoting()
    local content = self:GetWinningContent()

    self.OnEndVote:Fire(content)
    self.Client.OnEndVote:FireAll(content)
    self.Time = 0
    self.ContentOnVoting = nil
    table.clear(self.ListVoted)
end

function VotingService:CreateContent(name, iconId)
    return {
        Name = name;
        IconId = iconId;
        CountVoting = 0;
    }
end

function VotingService:CastInContent(table)
    table.Name = table.Name or ''
    table.IconId = table.IconId or ''
    table.CountVoting = 0

    return table
end

function VotingService:StartVoting(content, countItemOnVoting, time)
    if #content < countItemOnVoting then
        error('Insufficient amount of content for voting')
    end

    local contentOnVoting = {}
    local cloneContent = table.clone(content)

    for i = 1, countItemOnVoting, 1 do
        local index = math.random(1, #cloneContent)
        table.insert(contentOnVoting, cloneContent[index])
        table.remove(cloneContent, index)
    end

    self.Client.OnStartVoting:FireAll(contentOnVoting)
    self.ContentOnVoting = contentOnVoting
    self.Time = time
    
    table.clear(self.ListVoted)
end

function VotingService:KnitInit()
    task.spawn(function()
        while task.wait() do
            if self.Time <= 0 then
                continue
            end

            task.wait(1)

            self.Time -= 1
            self.Client.OnChangeTime:FireAll(self.Time)

            if self.Time <= 0 then
                self:EndVoting()
            end
        end
    end)

    Players.PlayerAdded:Connect(function(player)
        if self.ContentOnVoting == nil then return end
        self.Client.OnStartVoting:Fire(player, self.ContentOnVoting)
    end)

    print(self.Name..` inited.`);
end

return VotingService