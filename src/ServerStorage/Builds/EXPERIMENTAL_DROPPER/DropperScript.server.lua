local tycoon = script.Parent.Parent.Parent

repeat task.wait(0.1) until tycoon.Values.OwnerValue.Value ~= nil

local dropperPartsFolder = tycoon:FindFirstChild("DropperParts")
local dropColorValue = tycoon.Values.DropColorValue
local materialValue = tycoon.Values.MaterialValue
local sparklingValue = tycoon.Values.Sparkling
local storageValue = tycoon.Values.Storage
local boostsFolder = tycoon.Boosts
local billboardGuiTemplate = game.ReplicatedStorage:FindFirstChild("BillboardGui")

local DROPPER_REFLECTANCE = 0.45
local BASE_CASH = 5

local pendingCash = 0
local isRunning = false

local function isStorageFull()
	if storageValue and storageValue:GetAttribute("StorageCapacity") then
		return storageValue.Value >= storageValue:GetAttribute("StorageCapacity")
	end
	return false
end

function createDrop()
	if isStorageFull() then
		isRunning = false
		pendingCash += BASE_CASH
		return
	end

	isRunning = true

	local ownerBoosts = tycoon.Values.OwnerValue.Value:FindFirstChild("Boosts")
	if not ownerBoosts or not ownerBoosts:FindFirstChild("DiamondHandsBonus") then
		warn("Boost error!")
		return
	end

	local part = Instance.new("Part")
	part.Size = Vector3.new(1, 1, 1)
	part.BrickColor = dropColorValue.Value
	part.Material = materialValue.Value
	part.Name = "DropperPart"
	part.CFrame = script.Parent.Spawner.CFrame
	part.Parent = dropperPartsFolder

	local cashValue = Instance.new("IntValue")
	cashValue.Name = "CashValue"
	cashValue.Parent = part

	local randomChance = math.random(1, 100)
	local diamondHandsBonus = ownerBoosts.DiamondHandsBonus.Value

	if randomChance <= 30 and sparklingValue.Value then
		cashValue.Value = (BASE_CASH + pendingCash) * diamondHandsBonus * 1.2
		part.Reflectance = DROPPER_REFLECTANCE
	else
		cashValue.Value = (BASE_CASH + pendingCash) * diamondHandsBonus
	end

	pendingCash = 0

	if billboardGuiTemplate then
		local cloneGui = billboardGuiTemplate:Clone()
		cloneGui.Parent = part
		cloneGui.Frame.TextLabel.Text = "$" .. cashValue.Value .. " Cash"
	end

	local scriptClone = tycoon.Scripts.billboardCashUpdater:Clone()
	scriptClone.Parent = part

	game.Debris:AddItem(part, 15)
end

while true do
	local dropperCooldown = script.Parent:GetAttribute("DropperCooldown") or 1

	if boostsFolder.FasterDropSpeed.Value then
		dropperCooldown = dropperCooldown / 2
	end

	if boostsFolder.DoubleProductionRate.Value then
		createDrop()
		task.wait()
		createDrop()
	else
		createDrop()
	end

	task.wait(dropperCooldown)
end