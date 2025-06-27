local PartStorage = game.Workspace:WaitForChild("PartStorage")
local BillboardGui = game.ReplicatedStorage:FindFirstChild("BillboardGui")

while true do
	wait(1.75)
	local part = Instance.new("Part", PartStorage)

	part.BrickColor = BrickColor.new("Lime green")
	part.Material = script.Parent.Parent.Parent.MaterialValue.Value

	local cash = Instance.new("IntValue",part)
	cash.Name = "Cash"
	cash.Value = math.random(12, 16)

	part.CFrame = script.Parent.Drop3.CFrame - Vector3.new(2,0,0)
	part.FormFactor = "Custom"
	part.Size = Vector3.new(1.2, 1.2, 1.2)
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"

	local Value = BillboardGui:Clone()
	Value.Parent = part	

	game.Debris:AddItem(part, 20)
end