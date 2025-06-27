v = script.Parent.Parent.Value
click = script.Parent.ClickDetector

function wat(player)
	if player.TeamColor == script.Parent.Parent.Parent.Parent.TeamColor.Value then
		if v.Value == true then
			v.Value = false
			script.Parent.BrickColor = BrickColor.new("Really red")
			for i,v in pairs(script.Parent.Parent.Lasers:GetChildren()) do
				v.BrickColor = BrickColor.new("Bright green")
				v.Transparency = .8
			end
				
		elseif v.Value == false then
			v.Value = true
			script.Parent.BrickColor = BrickColor.new("Lime green")
			for i,v in pairs(script.Parent.Parent.Lasers:GetChildren()) do
				v.BrickColor = BrickColor.new("Bright red")
				v.Transparency = .2
			end
			
		end
	end
end

click.MouseClick:connect(wat)