wait(2)
workspace:WaitForChild("PartStorage")

while true do
	wait(3) -- How long in between drops
	local part = Instance.new("Part",workspace.PartStorage)
	part.BrickColor=script.Parent.Parent.Parent.DropColor.Value
	part.Material=script.Parent.Parent.Parent.MaterialValue.Value
	local cash = Instance.new("IntValue",part)
	cash.Name = "Cash"
	cash.Value = 25 -- How much the drops are worth
	part.CFrame = script.Parent.Drop.CFrame - Vector3.new(0,1.75,0)
	part.FormFactor = "Custom"
	part.Size=Vector3.new(1.25, 1.7, 1.7) -- Size of the drops
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	game.Debris:AddItem(part,20) -- How long until the drops expire
end