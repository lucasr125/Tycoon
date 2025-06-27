local debounce = {}
local replicatedStoarage = game:GetService("ReplicatedStorage")
local newCash

script.Parent.Touched:Connect(function(hit)
	if hit.Name == "DropperPart" then
		if not table.find(debounce, hit) then
			table.insert(debounce, hit)
			local C1 = hit:FindFirstChild("CashValue").Value
			hit:FindFirstChild("CashValue").Value = hit:FindFirstChild("CashValue").Value * 2
			local billboardClone = replicatedStoarage.BillboardGui:Clone()
			billboardClone.Parent = hit
			billboardClone.Frame.TextLabel.TextColor3 = Color3.new(1, 1, 0)
			newCash = hit:FindFirstChild("CashValue").Value - C1
			billboardClone.Frame.TextLabel.Text = "+ $"..newCash.." Cash"
			for i = 1, 30 do billboardClone.ExtentsOffset += Vector3.new(0, 0.1, 0) wait(0.01) end
			billboardClone:Destroy()
		end
	end
end)