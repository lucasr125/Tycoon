local rebirthEvent = game:GetService("ReplicatedStorage"):WaitForChild("RebirthEvent (Don't Move)")
local rebirthFrame = script.Parent:WaitForChild("RebirthFrame")
local button = rebirthFrame.Button
local title = rebirthFrame.Title

button.MouseButton1Down:Connect(function()
	rebirthEvent:FireServer()
end)

rebirthEvent.OnClientEvent:Connect(function(cashNeeded)
	if title.Visible then 
		title.Text = "You need a total of ".. cashNeeded .." cash to Rebirth."
		return
	end 
	title.Visible = true
	title.Text = "You need a total of ".. cashNeeded .." cash to Rebirth."
	wait(3)
	title.Visible = false
end)