local PartStorage = workspace:WaitForChild("PartStorage")

while true do
	wait(0.25) -- How long in between drops
	
	local part = Instance.new("Part", PartStorage)
	part.BrickColor = BrickColor.new("Teal")
	part.Material = script.Parent.Parent.Parent.MaterialValue.Value
	
	local billboardGui = game.ReplicatedStorage:FindFirstChild("BillboardGui"):Clone()
	local ScriptClone = game.ReplicatedStorage:FindFirstChild("UpdateValue"):Clone()
	billboardGui.Parent = part
	scriptClone.Parent = part
	
	local cash = Instance.new("IntValue",part)
	cash.Name = "Cash"
	cash.Value = 1 -- How much the drops are worth
	part.CFrame = script.Parent.Drop.CFrame - Vector3.new(0,1,0)
	part.FormFactor = "Custom"
	part.Size=Vector3.new(.5, .5, .5) -- Size of the drops
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	
	game.Debris:AddItem(part, 10) -- How long until the drops expire
end