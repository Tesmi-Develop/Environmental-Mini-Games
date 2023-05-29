local ServerScriptService = game:GetService("ServerScriptService")
local StatsValue = require(script.Parent.StatsValue);
local StatsTemplate = require(ServerScriptService.Core.Content.StatsTemplate)

local Stats = {}
Stats.__index = Stats
Stats.DataName = 'Stats'

function Stats.new(player)
    local self = setmetatable({}, Stats)
    self.Player = player
    self.Stats = {}

    return self
end

function Stats:Create(name: string, displayName: string,  data: table, defaultValue: number)
    local instance = StatsValue.new(name, displayName, data, defaultValue)
    self.Stats[name] = instance

    return StatsValue;
end

function Stats:Find(name: string)
    return self.Stats[name]
end

function Stats:Init()
    local Data = self.Player:GetData(Stats.DataName, {})
    
    for _, value in StatsTemplate do
        self:Create(value.Name, value.DisplayName, Data, value.DefaultValue)
    end
end

return Stats