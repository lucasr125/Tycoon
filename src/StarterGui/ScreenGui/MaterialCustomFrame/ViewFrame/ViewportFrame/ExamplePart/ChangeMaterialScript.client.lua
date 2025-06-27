local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local part = script.Parent

-- Aguarda o tycoon ser carregado corretamente
local tycoonOwned = plr:WaitForChild("ownedtycoon", math.huge)

-- Aguarda até o tycoon estar definido
repeat task.wait(1) until tycoonOwned.Value

-- Tenta obter a referência ao MaterialValue
local materialValue = tycoonOwned.Value:FindFirstChild("MaterialValue")

-- Função segura para converter e aplicar o material
local function applyMaterial(value)
	if typeof(value) == "string" and Enum.Material[value] then
		part.Material = Enum.Material[value]
	else
		warn("Material inválido:", value)
	end
end

-- Aplica o material atual (se existir)
if materialValue then
	applyMaterial(materialValue.Value)

	-- Conecta o evento da maneira correta
	materialValue:GetPropertyChangedSignal("Value"):Connect(function()
		applyMaterial(materialValue.Value)
	end)
else
	warn("MaterialValue não encontrado dentro do Tycoon.")
end
