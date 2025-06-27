task.wait(3)

local laser = script.Parent
local main = laser.Parent.Main
local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
local tweencreate = tween:Create(laser, tweeninfo, {Position = main.Attachment1.WorldPosition})
local tweencreate2 = tween:Create(laser, tweeninfo, {Position = main.Attachment2.WorldPosition})

while true do
	local tweencreate = tween:Create(laser, tweeninfo, {Position = main.Attachment1.WorldPosition})
	local tweencreate2 = tween:Create(laser, tweeninfo, {Position = main.Attachment2.WorldPosition})
	tweencreate:Play()
	wait(1)
	tweencreate2:Play()
	wait(1)
end