local debounce = {}

script.Parent.Upgrade.Touched:Connect(function(Part)
	if Part:FindFirstChild("Cash") and not table.find(debounce, Part) then
		Part.Cash.Value = Part.Cash.Value * 2
		table.insert(debounce, Part)
	end
end)