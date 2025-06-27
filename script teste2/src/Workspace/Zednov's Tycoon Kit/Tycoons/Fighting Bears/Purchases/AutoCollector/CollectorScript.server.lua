repeat task.wait(0.1) until script.Parent.Parent.Name == "PurchasedObjects"

local TweenService = game:GetService("TweenService")

local tycoon = script.Parent.Parent.Parent
local tycoonOwnerValue = tycoon.Owner
local model = script.Parent
local autoCollectorBool = tycoon.AutoCollector
local autoCollectorButton = model:WaitForChild("CollectorButton")
local displayLabel = model:WaitForChild("EnableCollector"):WaitForChild("Display").GUI.Amount

local isCollectorEnabled = false
local debounce = false

local ENABLED_COLOR = Color3.fromRGB(52, 142, 64)
local DISABLED_COLOR = Color3.fromRGB(142, 52, 53)

autoCollectorButton.Color = DISABLED_COLOR

autoCollectorButton.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)

	if not player then return end
	if player ~= tycoonOwnerValue.Value then return end

	if isCollectorEnabled then
		if debounce == false then
			debounce = true
			TweenService:Create(autoCollectorButton, TweenInfo.new(0.35), {Color = DISABLED_COLOR}):Play()
			isCollectorEnabled = false
			print("Disabling collector")
			displayLabel.Text = "Disabled"
			autoCollectorBool.Value = false
			task.delay(0.75, function() debounce = false end)
		end
	else
		if debounce == false then
			debounce = true
			TweenService:Create(autoCollectorButton, TweenInfo.new(0.25), {Color = ENABLED_COLOR}):Play()
			isCollectorEnabled = true
			print("Enabling collector")
			displayLabel.Text = "Enabled"
			autoCollectorBool.Value = true
			task.delay(0.75, function() debounce = false end)
		end
	end
end)