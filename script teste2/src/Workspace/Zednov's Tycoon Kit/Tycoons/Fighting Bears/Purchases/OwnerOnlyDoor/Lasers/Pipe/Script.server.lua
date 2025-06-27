val = script.Parent.Parent.Parent.Value

function touc(part)
	local plr = game.Players:FindFirstChild(part.Parent.Name)
	if plr then
		local h = part.Parent:FindFirstChild("Humanoid")
		if h then
			if val.Value == true then
				if part.Parent.Name ~= script.Parent.Parent.Parent.Parent.Parent.Owner.Value.Character.Name then
				h.Health = 0
				end
			end
		end
	end
end
script.Parent.Touched:connect(touc)