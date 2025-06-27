local screenGui = script.Parent
local frame = screenGui:WaitForChild("Frame")

local startButton = frame.Start
local stopButton = frame.Stop
local closeButton = frame.Close
local giveCashButton = frame.Give
local openTestGuiButton = screenGui.OpenTestGui
local textBox = frame.TextBox


local touchAllTycoonButtons = game:GetService("ReplicatedStorage"):WaitForChild("TouchAllTycoonButtons")
local giveCashEvent =  game:GetService("ReplicatedStorage"):WaitForChild("GiveCash")

startButton.MouseButton1Down:Connect(function()
	local start = true
	touchAllTycoonButtons:FireServer(start)
end)

stopButton.MouseButton1Down:Connect(function()
	local start = false
	touchAllTycoonButtons:FireServer(start)
end)

closeButton.MouseButton1Down:Connect(function()
	frame.Visible = false
	openTestGuiButton.Visible = true
end)

openTestGuiButton.MouseButton1Down:Connect(function()
	frame.Visible = true
	openTestGuiButton.Visible = false
end)

giveCashButton.MouseButton1Down:Connect(function()
	local cash = textBox.Text
	giveCashEvent:FireServer(cash)
end)