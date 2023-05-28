local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Components = require(ReplicatedStorage.Packages.Components);
local GamePlayer = require(ServerScriptService.Core.ComponentsHandler)['GamePlayer']

local CoinComponent = Components.new({
    Tag = "Coin";
});

function CoinComponent:Construct()
    self.Cost = 1;
    self.SpeedVerticalAnimation = 3;
    self.SpeedRotationAnimation = 3;
    self.Angle = 0;
    self.Position = self.Instance.Position
    self.HeightAnimation = 1;
    self.Connection = nil
end

function CoinComponent:Stop()
    if self.Connection then
        self.Connection:Disconnect()
    end
end

function CoinComponent:Start()
    local instance = self.Instance :: BasePart

    instance.CanCollide = false

    instance.Touched:Connect(function(otherPart)
        local player = Players:GetPlayerFromCharacter(otherPart.Parent)

        if player then
            GamePlayer.FindPlayer(player).Stats:Find('Money'):GiveValue(self.Cost)
            instance:Destroy()
        end
    end)

    self.Connection = RunService.Stepped:Connect(function(time, deltaTime)
        self.Angle += self.SpeedVerticalAnimation
        local newPosition = Vector3.new(self.Position.X, self.Position.Y + self.HeightAnimation * math.cos(math.rad(self.Angle)), self.Position.Z)
        self.Instance.Position = newPosition
        self.Instance.Orientation += Vector3.new(0, self.SpeedRotationAnimation, 0)
    end)
end

return CoinComponent;