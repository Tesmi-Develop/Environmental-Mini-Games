local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)

local GUIGrid = {}
GUIGrid.__index = GUIGrid

function GUIGrid.new(Scroll, Cell)
	local self = setmetatable({}, GUIGrid)
	self.Scroll = Scroll
	self.Cell = Cell

	self.OnCellCreate = Signal.new()
	self.OnMouseClick = Signal.new()
	
	return self
end      

function GUIGrid:CreateCell(Number)
	local Cell = self.Cell:Clone()
	Cell.Visible = true
	Cell.Parent = self.Scroll
	
	self.OnCellCreate:Fire(Cell, Number)

	Cell.Button.MouseButton1Down:Connect(function()
		self.OnMouseClick:Fire(Cell, Number)
	end)
end

function GUIGrid:DestroyCells()
	for i, cell in pairs(self.Scroll:GetChildren()) do
		if not cell:IsA(self.Cell.ClassName) then continue end
		
		cell:Destroy()
	end
end

function GUIGrid:UpdateCells(count)
	-- Destroy cells
	self:DestroyCells()
	
	for i = 1, count do
		self:CreateCell(i)
	end
end

return GUIGrid
