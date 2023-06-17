local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local VotingService = nil

local VotingGui = Player:WaitForChild('PlayerGui'):WaitForChild('VotingGui')
local MainFrame = VotingGui.Main
local GUIGrid = require(ReplicatedStorage.Libraries.GUIGrid)

local VotingController = Knit.CreateController({
    Name = "VotingController",
    Content = nil;
    GUIGrid = GUIGrid.new(MainFrame.List, MainFrame.Map);
})

function VotingController:KnitStart()
    VotingService = Knit.GetService('VotingService')
    VotingGui.Enabled = false

    self.GUIGrid.OnCellCreate:Connect(function(cell: ImageLabel, number)
        if self.Content == nil then return end

        local map = self.Content[number]
        cell.Name = tostring(number)
        cell.MapName.Text = map.Name
        cell.Votes.Text = tostring(map.CountVoting)
        cell.Image = `rbxassetid://${map.IconId}`
    end)

    self.GUIGrid.OnMouseClick:Connect(function(cell, number)
        if self.Content == nil then return end

        VotingService:Vote(number)
    end)

    VotingService.OnUpdateCountVote:Connect(function(index, countVoting)
        local cell = MainFrame.List:FindFirstChild(tostring(index))
        cell.Votes.Text = tostring(countVoting)
    end)

    VotingService.OnStartVoting:Connect(function(content)
        self.Content = content
        VotingGui.Enabled = true
        self.GUIGrid:UpdateCells(#content)
    end)

    VotingService.OnEndVote:Connect(function()
        VotingGui.Enabled = false
    end)

    VotingService.OnChangeTime:Connect(function(time)
        MainFrame.VotingTime.Text = `MAP VOTING : {time} SECONDS LEFT`
    end)
end

return VotingController