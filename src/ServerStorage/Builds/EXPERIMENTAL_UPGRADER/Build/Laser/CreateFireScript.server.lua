local Laser = script.Parent
local debounce = {}

Laser.Touched:Connect(function(hit)
	if hit:IsA("BasePart") and hit:FindFirstChild("CashValue") and not table.find(debounce, hit) then
		table.insert(debounce, hit)
		local Fire = Instance.new("Fire")
		Fire.Parent = hit
		Fire.Color = script.Parent.Parent:FindFirstChild("Wedge").Color
		Fire.SecondaryColor = script.Parent.Parent:FindFirstChild("Wedge").Color
	end
end)