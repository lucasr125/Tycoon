local changeMaterial = script.Parent.ChangeMaterial
local changeColor = script.Parent.ChangeColor

changeMaterial.OnServerEvent:Connect(function(plr, material)
	if plr == script.Parent.Owner.Value then
		script.Parent.MaterialValue.Value = tostring(material)
	end
end)

changeColor.OnServerEvent:Connect(function(plr, color)
	if plr == script.Parent.Owner.Value then
		script.Parent.DropColor.Value = color
	end
end)