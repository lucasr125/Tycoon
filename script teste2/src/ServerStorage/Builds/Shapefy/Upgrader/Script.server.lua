local debounce = {}

script.Parent.Touched:Connect(function(hit)
	if hit.Name == "DropperPart" then
		if not table.find(debounce, hit) then
			table.insert(debounce, hit)
			hit.Shape = Enum.PartType.Ball
		end
	end
end)