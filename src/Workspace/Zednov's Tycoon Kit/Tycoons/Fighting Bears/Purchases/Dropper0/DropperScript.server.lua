local Dropper = script.Parent
local PartStorage = game:GetService("Workspace"):WaitForChild("PartStorage")

while task.wait() do
	local DropColor = script.Parent.Parent.Parent.DropColor
	local DropMaterial = script.Parent.Parent.Parent.MaterialValue
	local Part = Instance.new("Part", PartStorage)
	Part.Color = DropColor.Value
	Part.Material = DropMaterial.Value
	Part.CFrame = script.Parent.Spawner.CFrame - Vector3.new(0, 1, 0)
	Part.Size = Vector3.new(0.5, 1, 0.8)
	Part.TopSurface = Enum.SurfaceType.Smooth
	Part.BottomSurface = Enum.SurfaceType.Smooth

	local Cash = Instance.new("IntValue", Part)
	Cash.Name = "Cash"
	Cash.Value = 8

	game:GetService("Debris"):AddItem(Part, 20)
	task.wait(1.4)
	Debounce = false
end