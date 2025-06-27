
local UIS = game:GetService("UserInputService")
local Dragging = false

script.Parent.TextButton.MouseButton1Down:Connect(function()
	Dragging = true
end)

local TargetChannel = "G" -- pode ser "G" ou "B"

function ChangeToValue(Percent)
	local viewPart = script.Parent.Parent.ViewFrame.ViewportFrame.ExamplePart
	local Value = math.floor(Percent * 255)

	local r = math.floor(viewPart.Color.R * 255)
	local g = math.floor(viewPart.Color.G * 255)
	local b = math.floor(viewPart.Color.B * 255)

	if TargetChannel == "R" then r = Value end
	if TargetChannel == "G" then g = Value end
	if TargetChannel == "B" then b = Value end

	viewPart.Color = Color3.fromRGB(r, g, b)
	script.Parent.PercentageValue.Text = tostring(Value)
	return Value
end


UIS.InputChanged:Connect(function()
	if Dragging then
		local MousePos = UIS:GetMouseLocation()+Vector2.new(0,-36)
		local RelPos = MousePos-script.Parent.AbsolutePosition
		local Percent = math.clamp(RelPos.X/script.Parent.AbsoluteSize.X,0,1)

		script.Parent.TextButton.Position = UDim2.new(Percent,0,script.Parent.TextButton.Position.Y.Scale,0)
		local FinalValue = ChangeToValue(Percent)

		script.Parent.Percentage.Value = FinalValue
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end
end)