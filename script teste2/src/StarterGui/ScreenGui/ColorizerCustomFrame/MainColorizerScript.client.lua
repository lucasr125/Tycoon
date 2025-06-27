--[[local frame = script.Parent
local TweenService = game:GetService("TweenService")

local rTextBox = frame.RedValueSlide.PercentageValue
local gTextBox = frame.GreenValueSlide.PercentageValue
local bTextBox = frame.BlueValueSlide.PercentageValue
local hexTextBox = frame.HEXModeFrame.HEXBox
local hsvTextBox = frame.HSVModeFrame.HSVBox
local viewPart = frame.ViewFrame.ViewportFrame.ExamplePart
local recentFrame = frame:WaitForChild("RecentColorsFrame")
local colorTemplate = recentFrame:WaitForChild("TemplateColorButton")
local closeButton = frame:WaitForChild("CloseButton")
local applyButton = frame:WaitForChild("ApplyColorButton")

local MAX_RECENT = 15
local recentColors = {}
local updating = false

function addRecentColor(color)
	if #recentColors > 0 and recentColors[1]:ToHex() == color:ToHex() then return end
	table.insert(recentColors, 1, color)
	if #recentColors > MAX_RECENT then
		table.remove(recentColors, #recentColors)
	end
	updateRecentFrame()
end

function updateRecentFrame()
	for _, child in ipairs(recentFrame:GetChildren()) do
		if child:IsA("GuiButton") and child.Name ~= "TemplateColorButton" then
			child:Destroy()
		end
	end
	for i, color in ipairs(recentColors) do
		local newBtn = colorTemplate:Clone()
		newBtn.Visible = true
		newBtn.Parent = recentFrame
		newBtn.Name = "Color" .. i
		newBtn.BackgroundColor3 = color
		newBtn.MouseButton1Click:Connect(function()
			viewPart.Color = color
		end)
	end
end

local function updateTextBoxes(color)
	updating = true

	local h, s, v = color:ToHSV()
	local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)

	hexTextBox.Text = "#" .. color:ToHex():upper()
	hsvTextBox.Text = math.floor(h * 360) .. ", " .. math.floor(s * 100) .. ", " .. math.floor(v * 100)
	rTextBox.Text = tostring(r)
	gTextBox.Text = tostring(g)
	bTextBox.Text = tostring(b)

	updating = false
end

local function setColor(color)
	if not color then return end
	viewPart.Color = color
	updateTextBoxes(color)
end

viewPart:GetPropertyChangedSignal("Color"):Connect(function()
	if updating then return end
	updateTextBoxes(viewPart.Color)
	frame.NewDropValue.Value = viewPart.Color
	addRecentColor(viewPart.Color)
end)

local function hexToColor3(hex)
	hex = hex:gsub("#", "")
	if #hex ~= 6 then return nil end
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	if r and g and b then
		return Color3.fromRGB(r, g, b)
	end
	return nil
end

local function markInvalid(textBox, invalid)
	local oTextColor3 = textBox.TextColor3
	textBox.TextColor3 = invalid and Color3.fromRGB(255, 80, 80) or Color3.new(1, 1, 1)
	task.delay(0.5, function()
		textBox.TextColor3 = oTextColor3
	end)
end

hexTextBox.FocusLost:Connect(function(enter)
	if not enter or updating then return end
	local color = hexToColor3(hexTextBox.Text)
	if color then
		markInvalid(hexTextBox, false)
		setColor(color)
	else
		markInvalid(hexTextBox, true)
	end
end)

local function updateFromRGB()
	if updating then return end
	local r = tonumber(rTextBox.Text)
	local g = tonumber(gTextBox.Text)
	local b = tonumber(bTextBox.Text)
	local valid = r and g and b and r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255
	markInvalid(rTextBox, not (r and r >= 0 and r <= 255))
	markInvalid(gTextBox, not (g and g >= 0 and g <= 255))
	markInvalid(bTextBox, not (b and b >= 0 and b <= 255))
	if valid then
		setColor(Color3.fromRGB(r, g, b))
	end
end

rTextBox.FocusLost:Connect(function() updateFromRGB() end)
gTextBox.FocusLost:Connect(function() updateFromRGB() end)
bTextBox.FocusLost:Connect(function() updateFromRGB() end)

hsvTextBox.FocusLost:Connect(function(enter)
	if not enter or updating then return end
	local h, s, v = hsvTextBox.Text:match("(%d+)[,; ]+(%d+)[,; ]+(%d+)")
	h = tonumber(h)
	s = tonumber(s)
	v = tonumber(v)
	local valid = h and s and v and h >= 0 and h <= 360 and s >= 0 and s <= 100 and v >= 0 and v <= 100
	markInvalid(hsvTextBox, not valid)
	if valid then
		setColor(Color3.fromHSV(h / 360, s / 100, v / 100))
	end
end)

local Players = game:GetService("Players")
local localplr = Players.LocalPlayer

local ownedtycoon
repeat
	ownedtycoon = localplr:FindFirstChild("ownedtycoon")
	task.wait(1)
until ownedtycoon and ownedtycoon.Value

local plrtycoon = ownedtycoon.Value
local changeColorRemote = plrtycoon:WaitForChild("ChangeColor")

applyButton.MouseButton1Click:Connect(function()
	changeColorRemote:FireServer(frame.NewDropValue.Value)
end)
]]

local frame = script.Parent
local TweenService = game:GetService("TweenService")

local rTextBox = frame.RedValueSlide.PercentageValue
local gTextBox = frame.GreenValueSlide.PercentageValue
local bTextBox = frame.BlueValueSlide.PercentageValue
local hexTextBox = frame.HEXModeFrame.HEXBox
local hsvTextBox = frame.HSVModeFrame.HSVBox
local viewPart = frame.ViewFrame.ViewportFrame.ExamplePart
local recentFrame = frame:WaitForChild("RecentColorsFrame")
local colorTemplate = recentFrame:WaitForChild("TemplateColorButton")
local closeButton = frame:WaitForChild("CloseButton")
local applyButton = frame:WaitForChild("ApplyColorButton")

local MAX_RECENT = 15
local recentColors = {}
local updating = false

function tweenFadeIn(gui)
	gui.BackgroundTransparency = 1
	gui.TextTransparency = 1
	TweenService:Create(gui, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		BackgroundTransparency = 0,
		TextTransparency = 0
	}):Play()
end

function addRecentColor(color)
	if #recentColors > 0 and recentColors[1]:ToHex() == color:ToHex() then return end
	table.insert(recentColors, 1, color)
	if #recentColors > MAX_RECENT then
		table.remove(recentColors, #recentColors)
	end
	updateRecentFrame()
end

function updateRecentFrame()
	for _, child in ipairs(recentFrame:GetChildren()) do
		if child:IsA("GuiButton") and child.Name ~= "TemplateColorButton" then
			child:Destroy()
		end
	end
	for i, color in ipairs(recentColors) do
		local newBtn = colorTemplate:Clone()
		newBtn.Visible = true
		newBtn.Parent = recentFrame
		newBtn.Name = "Color" .. i
		newBtn.BackgroundColor3 = color
		newBtn.AutoButtonColor = false

		-- Tween ao aparecer
		newBtn.BackgroundTransparency = 1
		TweenService:Create(newBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
			BackgroundTransparency = 0
		}):Play()

		-- Hover effect
		newBtn.MouseEnter:Connect(function()
			TweenService:Create(newBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.2)
			}):Play()
		end)
		newBtn.MouseLeave:Connect(function()
			TweenService:Create(newBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = color
			}):Play()
		end)

		newBtn.MouseButton1Click:Connect(function()
			viewPart.Color = color
		end)
	end
end

local function updateTextBoxes(color)
	updating = true

	local h, s, v = color:ToHSV()
	local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)

	hexTextBox.Text = "#" .. color:ToHex():upper()
	hsvTextBox.Text = math.floor(h * 360) .. ", " .. math.floor(s * 100) .. ", " .. math.floor(v * 100)
	rTextBox.Text = tostring(r)
	gTextBox.Text = tostring(g)
	bTextBox.Text = tostring(b)

	updating = false
end

local function setColor(color)
	if not color then return end
	TweenService:Create(viewPart, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Color = color
	}):Play()
	updateTextBoxes(color)
end

viewPart:GetPropertyChangedSignal("Color"):Connect(function()
	if updating then return end
	updateTextBoxes(viewPart.Color)
	frame.NewDropValue.Value = viewPart.Color
	addRecentColor(viewPart.Color)
end)

local function hexToColor3(hex)
	hex = hex:gsub("#", "")
	if #hex ~= 6 then return nil end
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	if r and g and b then
		return Color3.fromRGB(r, g, b)
	end
	return nil
end

local function markInvalid(textBox, invalid)
	local originalColor = textBox.TextColor3
	if invalid then
		TweenService:Create(textBox, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
			TextColor3 = Color3.fromRGB(255, 80, 80)
		}):Play()
		task.delay(0.4, function()
			TweenService:Create(textBox, TweenInfo.new(0.2), {
				TextColor3 = originalColor
			}):Play()
		end)
	else
		textBox.TextColor3 = originalColor
	end
end

hexTextBox.FocusLost:Connect(function(enter)
	if not enter or updating then return end
	local color = hexToColor3(hexTextBox.Text)
	if color then
		markInvalid(hexTextBox, false)
		setColor(color)
	else
		markInvalid(hexTextBox, true)
	end
end)

local function updateFromRGB()
	if updating then return end
	local r = tonumber(rTextBox.Text)
	local g = tonumber(gTextBox.Text)
	local b = tonumber(bTextBox.Text)
	local valid = r and g and b and r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255
	markInvalid(rTextBox, not (r and r >= 0 and r <= 255))
	markInvalid(gTextBox, not (g and g >= 0 and g <= 255))
	markInvalid(bTextBox, not (b and b >= 0 and b <= 255))
	if valid then
		setColor(Color3.fromRGB(r, g, b))
	end
end

rTextBox.FocusLost:Connect(updateFromRGB)
gTextBox.FocusLost:Connect(updateFromRGB)
bTextBox.FocusLost:Connect(updateFromRGB)

hsvTextBox.FocusLost:Connect(function(enter)
	if not enter or updating then return end
	local h, s, v = hsvTextBox.Text:match("(%d+)[,; ]+(%d+)[,; ]+(%d+)")
	h = tonumber(h)
	s = tonumber(s)
	v = tonumber(v)
	local valid = h and s and v and h >= 0 and h <= 360 and s >= 0 and s <= 100 and v >= 0 and v <= 100
	markInvalid(hsvTextBox, not valid)
	if valid then
		setColor(Color3.fromHSV(h / 360, s / 100, v / 100))
	end
end)

local Players = game:GetService("Players")
local localplr = Players.LocalPlayer

local ownedtycoon
repeat
	ownedtycoon = localplr:FindFirstChild("ownedtycoon")
	task.wait(1)
until ownedtycoon and ownedtycoon.Value

local plrtycoon = ownedtycoon.Value
local changeColorRemote = plrtycoon:WaitForChild("ChangeColor")

applyButton.MouseButton1Click:Connect(function()
	TweenService:Create(applyButton, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
		TextColor3 = Color3.new(0.7, 1, 0.7)
	}):Play()
	task.delay(0.4, function()
		TweenService:Create(applyButton, TweenInfo.new(0.15), {
			TextColor3 = Color3.new(1, 1, 1)
		}):Play()
	end)
	changeColorRemote:FireServer(frame.NewDropValue.Value)
end)

closeButton.MouseButton1Click:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, -1)}):Play()
end)