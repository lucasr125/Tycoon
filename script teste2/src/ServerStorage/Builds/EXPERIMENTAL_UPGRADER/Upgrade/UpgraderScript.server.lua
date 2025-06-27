local debounce = {}
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

script.Parent.Touched:Connect(function(hit)
	if hit.Name ~= "DropperPart" then return end

	if debounce[hit] then return end
	debounce[hit] = true

	local cashValue = hit:FindFirstChild("CashValue")
	if not cashValue then
		debounce[hit] = nil
		return
	end

	local oldCash = cashValue.Value
	cashValue.Value *= 2
	local cashEarned = cashValue.Value - oldCash

	local billboardClone = replicatedStorage.BillboardGui:Clone()
	billboardClone.Parent = hit
	billboardClone.Frame.TextLabel.TextColor3 = Color3.new(1, 1, 0)
	billboardClone.Frame.TextLabel.Text = "+ $" .. cashEarned .. " Cash"

	local tweenInfo = TweenInfo.new(
		0.3,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)
	local tween = tweenService:Create(
		billboardClone,
		tweenInfo,
		{ ExtentsOffset = Vector3.new(0, 3, 0) }
	)
	tween:Play()

	task.delay(0.3, function()
		billboardClone:Destroy()
		debounce[hit] = nil
	end)
end)