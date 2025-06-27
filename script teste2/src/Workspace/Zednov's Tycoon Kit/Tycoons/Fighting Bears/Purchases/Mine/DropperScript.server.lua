local Mine = script.Parent
local AutomaticMine = Mine.AutomaticMine
local AutomaticClicker = AutomaticMine.Clicker
local ManualMine = Mine.ManualMine
local ManualClicker = ManualMine.Clicker
local PartStorage = game:GetService("Workspace"):WaitForChild("PartStorage")
local Debounce = false
local AutomaticIsEnabled = false
local AutoMineTask

ManualClicker.ClickDetector.MouseClick:Connect(function()
	if not Debounce and not AutomaticIsEnabled then
		ManualClicker.Color = Color3.fromRGB(154, 76, 76)
		Debounce = true

		local DropColor = script.Parent.Parent.Parent.DropColor
		local DropMaterial = script.Parent.Parent.Parent.MaterialValue
		local Part = Instance.new("Part", PartStorage)
		Part.Color = DropColor.Value
		Part.Material = DropMaterial.Value
		Part.CFrame = script.Parent.Spawner.CFrame - Vector3.new(0, 1, 0)
		Part.Size = Vector3.new(0.5, 1, 0.7)
		Part.TopSurface = Enum.SurfaceType.Smooth
		Part.BottomSurface = Enum.SurfaceType.Smooth

		local Cash = Instance.new("IntValue", Part)
		Cash.Name = "Cash"
		Cash.Value = 1

		game:GetService("Debris"):AddItem(Part, 20)
		task.wait(0.15)
		Debounce = false
		ManualClicker.Color = Color3.fromRGB(91, 154, 76)
	end
end)

AutomaticClicker.ClickDetector.MouseClick:Connect(function()
	if not Debounce then
		Debounce = true
		AutomaticIsEnabled = not AutomaticIsEnabled

		if AutomaticIsEnabled then
			ManualClicker.Color = Color3.fromRGB(154, 76, 76)
			AutoMineTask = task.spawn(function()
				while AutomaticIsEnabled do
					local DropColor = script.Parent.Parent.Parent.DropColor
					local DropMaterial = script.Parent.Parent.Parent.MaterialValue
					local Part = Instance.new("Part", PartStorage)
					Part.Color = DropColor.Value
					Part.Material = DropMaterial.Value
					Part.CFrame = script.Parent.Spawner.CFrame - Vector3.new(0, 1, 0)
					Part.Size = Vector3.new(0.5, 1, 0.7)
					Part.TopSurface = Enum.SurfaceType.Smooth
					Part.BottomSurface = Enum.SurfaceType.Smooth

					local Cash = Instance.new("IntValue", Part)
					Cash.Name = "Cash"
					Cash.Value = 1

					game:GetService("Debris"):AddItem(Part, 20)
					task.wait(0.5)
				end
			end)
		else
			ManualClicker.Color = Color3.fromRGB(91, 154, 76)
		end
		task.wait(0.2)
		Debounce = false
	end
end)
