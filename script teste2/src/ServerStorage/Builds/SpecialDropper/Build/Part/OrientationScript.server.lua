local part = script.Parent

while wait() do
	part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(5), 0)
end