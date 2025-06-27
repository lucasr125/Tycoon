-- LocalScript dentro do ViewportFrame
-- Caminho: StarterGui.ScreenGui.MaterialCustomFrame.ViewportFrame

local viewportFrame = script.Parent -- O ViewportFrame onde este script está
local examplePart = viewportFrame:WaitForChild("ExamplePart") -- A parte dentro do ViewportFrame

-- Criar uma câmera para o ViewportFrame
local camera = Instance.new("Camera")
camera.Parent = viewportFrame

-- Conectar a câmera ao ViewportFrame
viewportFrame.CurrentCamera = camera

-- Variáveis de zoom
local zoomDistance = 5 -- Distância inicial da câmera
local minZoom = 2 -- Zoom mínimo (mais próximo)
local maxZoom = 20 -- Zoom máximo (mais longe)
local baseOffset = Vector3.new(3, 2, 5) -- Offset base da câmera

-- Função para posicionar a câmera com zoom
local function updateCamera()
	-- Calcular offset baseado no zoom
	local scaledOffset = baseOffset.Unit * zoomDistance
	local cameraPosition = examplePart.Position + scaledOffset

	-- Fazer a câmera olhar para a parte
	camera.CFrame = CFrame.lookAt(cameraPosition, examplePart.Position)
end

-- Criar botões de zoom
local zoomInButton = Instance.new("TextButton")
zoomInButton.Size = UDim2.new(0, 30, 0, 30)
zoomInButton.Position = UDim2.new(1, -35, 0, 5)
zoomInButton.Text = "+"
zoomInButton.Name = "ZoomInButton"
zoomInButton.TextScaled = true
zoomInButton.TextColor3 = Color3.new(1, 1, 1)
zoomInButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
zoomInButton.BorderSizePixel = 0
zoomInButton.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
zoomInButton.Parent = viewportFrame
zoomInButton.Font = Enum.Font.FredokaOne

local zoomOutButton = Instance.new("TextButton")
zoomOutButton.Size = UDim2.new(0, 30, 0, 30)
zoomOutButton.Position = UDim2.new(1, -35, 0, 40)
zoomOutButton.Text = "-"
zoomOutButton.Name = "ZoomOutButton"
zoomOutButton.TextScaled = true
zoomOutButton.TextColor3 = Color3.new(1, 1, 1)
zoomOutButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
zoomOutButton.BorderSizePixel = 0
zoomOutButton.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
zoomOutButton.Parent = viewportFrame
zoomOutButton.Font = Enum.Font.FredokaOne

-- Eventos dos botões
zoomInButton.MouseButton1Click:Connect(function()
	zoomDistance = math.max(minZoom, zoomDistance - 1)
	updateCamera()
end)

zoomOutButton.MouseButton1Click:Connect(function()
	zoomDistance = math.min(maxZoom, zoomDistance + 1)
	updateCamera()
end)

-- Scroll do mouse para zoom (opcional)
viewportFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		if input.Position.Z > 0 then
			-- Scroll up = zoom in
			zoomDistance = math.max(minZoom, zoomDistance - 0.5)
		else
			-- Scroll down = zoom out
			zoomDistance = math.min(maxZoom, zoomDistance + 0.5)
		end
		updateCamera()
	end
end)

-- Executar inicialmente
updateCamera()

-- Atualizar câmera sempre que a parte se mover/rotacionar
examplePart:GetPropertyChangedSignal("CFrame"):Connect(updateCamera)
examplePart:GetPropertyChangedSignal("Position"):Connect(updateCamera)