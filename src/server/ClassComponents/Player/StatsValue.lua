local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)

local StatsValue = {}
StatsValue.__index = StatsValue

function StatsValue.new(name: string, displayName: string, profileData: table, defaultValue: number)
    local self = setmetatable({}, StatsValue)
    self.Name = name
    self.DisplayName = displayName
    self.ProfileData = profileData
    self.OnChangeValue = Signal.new();
    
    if self:GetValue() == nil then
        self:SetValue(defaultValue)
    end

    return self
end

function StatsValue:Update()
    self.OnChangeValue:Fire(self:GetValue())
end

function StatsValue:GetValue()
    return self.ProfileData[self.Name]
end

function StatsValue:GiveValue(value: number)
    self.ProfileData[self.Name] += value
    self:Update()
end

function StatsValue:TakeValue(value: number)
    self.ProfileData[self.Name] -= value
    self:Update()
end

function StatsValue:SetValue(value: number)
    self.ProfileData[self.Name] = value
    self:Update()
end

return StatsValue