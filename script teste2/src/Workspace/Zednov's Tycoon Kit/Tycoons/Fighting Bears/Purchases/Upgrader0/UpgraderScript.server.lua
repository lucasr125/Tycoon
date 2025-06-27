local Debounce = {}
local Upgrade = script.Parent.Upgrade

Upgrade.Touched:Connect(function(Part)
	if Part:FindFirstChild("Cash") and not table.find(debounce, Part) then
		Part.Cash.Value = Part.Cash.Value * 1.5
		table.insert(Debounce, Part)
		task.delay(2, function()
			table.remove(Debounce, Part)
		end)
	end
end)