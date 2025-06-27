repeat wait(1) until script.Parent:IsA("Model") == true
repeat wait(1) until script.Parent.Parent.Parent.Parent.Name == "Purchases"
wait(2)

local model = script.Parent

while wait() do
	model:SetPrimaryPartCFrame(model:GetPrimaryPartCFrame() * CFrame.Angles(math.rad(5), 0, 0))
end
