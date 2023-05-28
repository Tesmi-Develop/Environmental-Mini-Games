local ServerScriptService = game:GetService("ServerScriptService")
local LeaderstatsTemplate = require(ServerScriptService.Core.Content.LeaderstatsTemplate)
local Leaderstats = {}
Leaderstats.__index = Leaderstats

function Leaderstats.new(player)
    local self = setmetatable({}, Leaderstats)
    self.Player = player

    self.Folder = Instance.new('Folder', self.Player.Instance);
    self.Folder.Name = 'leaderstats'

    return self
end

function Leaderstats:CreateValue(value)
    local objectValue = Instance.new('NumberValue', self.Folder)
    objectValue.Name = value.DisplayName
    objectValue.Value = value:GetValue()

    value.OnChangeValue:Connect(function(num: number)
        objectValue.Value = num;
    end)
end

function Leaderstats:Init()
    for index, nameStatsValue in LeaderstatsTemplate do
        local statsValue = self.Player.Stats:Find(nameStatsValue)

        if statsValue == nil then
            warn('not found stats '..nameStatsValue)
            continue
        end

        self:CreateValue(statsValue)
    end
end

return Leaderstats