local tycoon = script.Parent.Parent.Parent

local dropperPartsFolder = tycoon:FindFirstChild("DropperParts")
local billboardGui = game.ReplicatedStorage:FindFirstChild("BillboardGui")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local meshPartToDropper = ReplicatedStorage.Meshes.Car:Clone()
meshPartToDropper.Parent = script.Parent
meshPartToDropper.Position = script.Parent.Build.Glass.MeshAttachment.WorldPosition
meshPartToDropper.Anchored = true

tycoon:FindFirstChild("Scripts"):FindFirstChild("OrientationPart"):Clone().Parent = meshPartToDropper


while wait(1) do
	local scriptClone = tycoon.Scripts.billboardCashUpdater:Clone()
	local cloneGui = billboardGui:Clone()

	local mesh = ReplicatedStorage.Meshes.Car:Clone()
	mesh.CFrame = script.Parent.Spawner.CFrame
	mesh.Parent = dropperPartsFolder
	mesh.Name = "DropperPart"

	local cashValue = Instance.new("IntValue", mesh)
	cashValue.Value = 2
	cashValue.Name = "CashValue"

	cloneGui.Parent = mesh
	ScriptClone.Parent = mesh
	cloneGui.Frame.TextLabel.Text = "$"..cashValue.Value.." Cash"

	game.Debris:AddItem(mesh, 15)
end