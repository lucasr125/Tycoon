local screenGui = script.Parent
local barButton = screenGui.BarButton
local barFrame = screenGui.BarFrame

--// Tycoon functions
local tycoonButton = screenGui:WaitForChild("BarFrame"):WaitForChild("TycoonButton")
local tycoonFrame = screenGui:WaitForChild("TycoonFrame")
local closeTycoonButton = tycoonFrame:WaitForChild("CloseButton")
local customizationTycoonButton = tycoonFrame:WaitForChild("CustomizationTycoonButton")
local customizationTycoonFrame = tycoonFrame:WaitForChild("CustomizationTycoonFrame")
local colorizerTycoonButton = customizationTycoonFrame:WaitForChild("ColorizerTycoonButton")
local materializerTycoonButton = customizationTycoonFrame:WaitForChild("MaterializerTycoonButton")
local colorizerFrame = screenGui:WaitForChild("ColorizerCustomFrame")
local materializerFrame = screenGui:WaitForChild("MaterialCustomFrame")

local TweenService = game:GetService("TweenService")

barButton.MouseEnter:Connect(function()
	TweenService:Create(barButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0.039, 0, 0.15, 0),
		Position = UDim2.new(0.032, 0, 0.877, 0)
	}):Play()
end)

barButton.MouseLeave:Connect(function()
	TweenService:Create(barButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0.029, 0, 0.121, 0),
		Position = UDim2.new(0.027, 0, 0.877, 0)
	}):Play()
end)

barButton.MouseButton1Click:Connect(function()
	local show = barFrame.Position.Y.Scale == 1.25
	if show then
		TweenService:Create(barFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
			Position = UDim2.new(0.118, 0, 0.815, 0)
		}):Play()
	else
		TweenService:Create(barFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
			Position = UDim2.new(0.118, 0, 1.25, 0)
		}):Play()
	end
end)


tycoonButton.MouseEnter:Connect(function()
	TweenService:Create(tycoonButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.116, 1.54)}):Play()
end)
tycoonButton.MouseLeave:Connect(function()
	TweenService:Create(tycoonButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.096, 1.32)}):Play()
end)
tycoonButton.MouseButton1Click:Connect(function()
	local show = tycoonFrame.Position.Y.Scale == -1
	if show then
		TweenService:Create(tycoonFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, 0.12)}):Play()
		TweenService:Create(materializerFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, -1)}):Play()
		TweenService:Create(colorizerFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, -1)}):Play()
	else
		TweenService:Create(tycoonFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, -1)}):Play()
	end
end)


--falta por descricao, funcao para os botoes abrirem
customizationTycoonButton.MouseEnter:Connect(function()
	TweenService:Create(customizationTycoonButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.2, 0.165)}):Play()
end)
customizationTycoonButton.MouseLeave:Connect(function()
	TweenService:Create(customizationTycoonButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.2, 0.125)}):Play()
end)
customizationTycoonButton.MouseButton1Click:Connect(function()
	local show = customizationTycoonFrame.Position.X.Scale < 0.02
	if show then
		customizationTycoonFrame.Visible = true
		customizationTycoonButton.Interactable = false
		customizationTycoonButton.AutoButtonColor = false
		TweenService:Create(customizationTycoonFrame, TweenInfo.new(0.35, Enum.EasingStyle.Sine), {Position = UDim2.fromScale(0.05, 0.15), Size = UDim2.fromScale(0.9, 0.75)}):Play()
		task.delay(0.35, function()
			customizationTycoonButton.Interactable = true
			customizationTycoonButton.AutoButtonColor = true
		end)
	else
		customizationTycoonButton.Interactable = false
		customizationTycoonButton.AutoButtonColor = false
		TweenService:Create(customizationTycoonFrame, TweenInfo.new(0.35, Enum.EasingStyle.Sine), {Position = UDim2.fromScale(0.01, 0.15), Size = UDim2.fromScale(0, 0.75)}):Play()
		task.delay(0.35, function()
			customizationTycoonFrame.Visible = false
			customizationTycoonButton.Interactable = true
			customizationTycoonButton.AutoButtonColor = true
		end)
	end
end)

colorizerTycoonButton.MouseButton1Click:Connect(function()
	TweenService:Create(tycoonFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, -1)}):Play()
	TweenService:Create(colorizerFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, 0.12)}):Play()
end)
materializerTycoonButton.MouseButton1Click:Connect(function()
	TweenService:Create(tycoonFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, -1)}):Play()
	TweenService:Create(materializerFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, 0.12)}):Play()
end)

closeTycoonButton.MouseEnter:Connect(function()
	TweenService:Create(closeTycoonButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.095, 0.2)}):Play()
end)
closeTycoonButton.MouseLeave:Connect(function()
	TweenService:Create(closeTycoonButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.065, 0.15)}):Play()
end)
closeTycoonButton.MouseButton1Click:Connect(function()
	TweenService:Create(tycoonFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, -1)}):Play()
end)