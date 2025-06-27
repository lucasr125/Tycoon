for i,v in pairs(script.Parent.Buttons:GetChildren()) do
	v.ClickDetector.MouseClick:connect(function()
		script.Parent.Parent.Parent.MaterialValue.Value = v.Material.Name
		script.Parent.Showing.Material = v.Material.Name
	end)
end