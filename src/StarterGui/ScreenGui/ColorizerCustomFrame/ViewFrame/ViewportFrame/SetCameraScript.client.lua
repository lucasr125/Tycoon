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
local baseOffset = Vector3.new(3, 2, 5) -- Offset base da câmera

-- Função para posicionar a câmera com zoom
local function updateCamera()
	-- Calcular offset baseado no zoom
	local scaledOffset = baseOffset.Unit * zoomDistance
	local cameraPosition = examplePart.Position + scaledOffset

	-- Fazer a câmera olhar para a parte
	camera.CFrame = CFrame.lookAt(cameraPosition, examplePart.Position)
end

updateCamera()

-- Atualizar câmera sempre que a parte se mover/rotacionar
examplePart:GetPropertyChangedSignal("CFrame"):Connect(updateCamera)
examplePart:GetPropertyChangedSignal("Position"):Connect(updateCamera)