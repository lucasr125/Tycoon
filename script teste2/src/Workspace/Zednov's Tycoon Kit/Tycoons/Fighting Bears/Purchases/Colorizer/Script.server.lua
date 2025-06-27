for i,v in pairs(script.Parent.Buttons:GetChildren()) do
	v.ClickDetector.MouseClick:connect(function()
		script.Parent.Parent.Parent.DropColor.Value = v.BrickColor
		script.Parent.Showing.BrickColor = v.BrickColor
	end)
end