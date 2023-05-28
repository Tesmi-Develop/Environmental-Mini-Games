local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Components = require(ReplicatedStorage.Packages.Components)
local CoinComponent = require(script.Parent.CoinComponent)
local CoinPart = ServerStorage.Items.Coin

local CoinSpawner = Components.new({
    Tag = "CoinSpawner",
})

function CoinSpawner:Construct()
    self.Cooldown = 60; -- time before the next attempt to create a coin
    self.Chance = 25 -- the chance that the coin will appear
    self.Coin = nil;
end

function CoinSpawner:Spawn()
    local instance = self.Instance :: BasePart
    local clone = CoinPart:Clone()
    clone.Parent = workspace;
    self.Coin = clone
    self.OffsetSpawn = 3;

    local Connection
    Connection = CoinComponent.Stopped:Connect(function(componet)
        if componet.Instance == clone then
            self.Coin = nil
            Connection:Disconnect()
        end
    end)

    clone.CFrame = instance.CFrame + Vector3.new(0, clone.Size.Y / 2 + self.OffsetSpawn, 0)
end

function CoinSpawner:Start()
    while task.wait() do
        if self.Coin ~= nil then
            continue
        end

        task.wait(self.Cooldown)

        local randomNumber = math.random(0, 100)

        if randomNumber >= 0 and randomNumber <= self.Chance then
            self:Spawn()
        end
    end
end

return CoinSpawner