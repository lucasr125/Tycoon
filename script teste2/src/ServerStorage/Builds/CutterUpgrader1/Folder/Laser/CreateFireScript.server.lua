--[[local Laser = script.Parent
local debounce = {}

Laser.Touched:Connect(function(hit)
	if hit:IsA("BasePart") and hit:FindFirstChild("CashValue") and not table.find(debounce, hit) then
		table.insert(debounce, hit)
		local Fire = Instance.new("Fire")
		Fire.Parent = hit
		Fire.Color = script.Parent.Parent:FindFirstChild("Wedge").Color
		Fire.SecondaryColor = script.Parent.Parent:FindFirstChild("Wedge").Color
	end
end)]]

local Laser = script.Parent
local debounce = {}

Laser.Touched:Connect(function(hit)
	if hit:IsA("BasePart") and hit:FindFirstChild("CashValue") and not table.find(debounce, hit) then
		table.insert(debounce, hit)

		-- Clonar o objeto atingido três vezes
		for i = 1, 3 do
			local clone = hit:Clone()
			clone.Size = (hit.Size / 2) * 1.5
			clone.Parent = hit.Parent
			clone.Position = hit.Position

			-- Adiciona o clone na tabela debounce
			table.insert(debounce, clone)

			-- Criar efeito de fogo em cada clone
			local fire = Instance.new("Fire")
			fire.Parent = clone
			fire.Color = script.Parent.Parent:FindFirstChild("Wedge").Color
			fire.SecondaryColor = script.Parent.Parent:FindFirstChild("Wedge").Color
		end

		-- Deletar o objeto original
		hit:Destroy()
	end
end)
