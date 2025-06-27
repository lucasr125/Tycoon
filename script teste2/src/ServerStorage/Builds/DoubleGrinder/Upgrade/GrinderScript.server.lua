local upgrade = script.Parent
local debounce = {}

upgrade.Touched:Connect(function(hit)
	if hit:IsA("BasePart") and hit:FindFirstChild("CashValue") and not table.find(debounce, hit) then
		table.insert(debounce, hit)
		for i = 1, upgrade.Parent:GetAttribute("CutPerDrop") do
			local clone = hit:Clone()
			clone.Size = (hit.Size / 2) * 1.5
			clone.Parent = hit.Parent
			clone.Position = hit.Position
			table.insert(debounce, clone)
			game.Debris:AddItem(clone, 10)
			task.wait()
		end
		hit:Destroy()
	end
end)