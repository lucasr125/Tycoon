local tycoon = script.Parent.Parent.Parent

local dropperPartsFolder = tycoon:FindFirstChild("DropperParts")
local dropColorValue = tycoon:FindFirstChild("Values").DropColorValue
local materialValue = tycoon:FindFirstChild("Values").MaterialValue

local billboardGui = game.ReplicatedStorage:FindFirstChild("BillboardGui")

while wait(2.3) do
	local scriptClone = tycoon.Scripts.billboardCashUpdater:Clone()
	local cloneGui = billboardGui:Clone()
	local part = Instance.new("Part", dropperPartsFolder)
	part.Size = Vector3.new(1, 1, 1)
	part.BrickColor = dropColorValue.Value
	part.Material = materialValue.Value
	part.Name = "DropperPart"
	part.CFrame = script.Parent.Spawner.CFrame

	local cashValue = Instance.new("IntValue", part)
	cashValue.Value = 9
	cashValue.Name = "CashValue"

	cloneGui.Parent = part
	scriptClone.Parent = part
	cloneGui.Frame.TextLabel.Text = "$"..cashValue.Value.." Cash"

	game.Debris:AddItem(part, 15)
end