local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Constants
local MAX_RECENT = 6
local availableMaterials = {
	"Plastic", "SmoothPlastic", "Neon", "Wood", "WoodPlanks", "Marble", "Basalt",
	"Slate", "CrackedLava", "Concrete", "Limestone", "Granite", "Pavement", "Brick",
	"Pebble", "Cobblestone", "Rock", "Sandstone", "CorrodedMetal", "DiamondPlate",
	"Foil", "Metal", "Grass", "LeafyGrass", "Sand", "Fabric", "Snow", "Mud", "Ground",
	"Asphalt", "Salt", "Ice", "Glacier", "Glass", "ForceField", "Cardboard", "Carpet",
	"CeramicTiles", "ClayRoofTiles", "RoofShingles", "Leather", "Plaster", "Rubber"
}

-- UI Elements
local frame = script.Parent
local dropdownBtn = frame:WaitForChild("DropdownButton")
local listFrame = frame:WaitForChild("MaterialList")
local template = listFrame:WaitForChild("MaterialTemplate")
local applyButton = frame:WaitForChild("ApplyMaterialButton")
local searchBox = frame:WaitForChild("SearchMaterialBox")
local nothingFoundLabel = listFrame:WaitForChild("NothingFoundText")
local viewPart = frame:WaitForChild("ViewFrame"):WaitForChild("ViewportFrame"):WaitForChild("ExamplePart")
local closeButton = frame:WaitForChild("CloseButton")
local actualMaterial = frame:WaitForChild("ActualMaterialText")
local recentFrame = frame.RecentMaterialFrame
local materialTemplate = recentFrame:FindFirstChild("TemplateMaterialButton")

-- Player and Remote
local localplr = Players.LocalPlayer
local ownedtycoon

repeat
	ownedtycoon = localplr:FindFirstChild("ownedtycoon")
	task.wait(1)
until ownedtycoon and ownedtycoon.Value

local plrtycoon = ownedtycoon.Value
local changeMaterialRemote = plrtycoon:WaitForChild("ChangeMaterial")

-- Material Mapping
local materialMap = {}
for _, enumItem in ipairs(Enum.Material:GetEnumItems()) do
	materialMap[enumItem.Name] = enumItem
end

-- State
local selectedMaterial = "Plastic"
local recentMaterials = {}

-- Initial State
listFrame.Visible = false
listFrame.Size = UDim2.new(0.34, 0, 0, 0)
searchBox.Visible = false

-- Dropdown Toggle
local function toggleDropdown()
	local show = listFrame.Size.Y.Scale == 0

	if show then
		listFrame.Visible = true
		TweenService:Create(listFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0.34, 0, 0.765, 0)
		}):Play()

		task.delay(0.05, function()
			searchBox.Visible = true
			TweenService:Create(searchBox, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0.319, 0, 0.062, 0)
			}):Play()
		end)
	else
		TweenService:Create(listFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0.34, 0, 0, 0)
		}):Play()

		task.delay(0.25, function()
			listFrame.Visible = false
			TweenService:Create(searchBox, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0.319, 0, 0, 0)
			}):Play()
			task.wait(0.25)
			searchBox.Visible = false
		end)
	end
end

-- Dropdown Hover
dropdownBtn.MouseEnter:Connect(function()
	TweenService:Create(dropdownBtn, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Size = UDim2.fromScale(0.27, 0.092)
	}):Play()
end)

dropdownBtn.MouseLeave:Connect(function()
	TweenService:Create(dropdownBtn, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Size = UDim2.fromScale(0.27, 0.062)
	}):Play()
end)

-- Apply Button Hover
applyButton.MouseEnter:Connect(function()
	TweenService:Create(applyButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Size = UDim2.fromScale(0.325, 0.08),
		Position = UDim2.fromScale(0.545, 0.009)
	}):Play()
end)

applyButton.MouseLeave:Connect(function()
	TweenService:Create(applyButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Size = UDim2.fromScale(0.292, 0.062),
		Position = UDim2.fromScale(0.576, 0.019)
	}):Play()
end)

-- Dropdown Open
dropdownBtn.MouseButton1Click:Connect(toggleDropdown)

-- Populate Material Buttons
for _, materialName in ipairs(availableMaterials) do
	if materialMap[materialName] then
		local btn = template:Clone()
		btn.Text = materialName
		btn.Name = materialName
		btn.Visible = true
		btn.Parent = listFrame

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(225, 225, 225)
			}):Play()
		end)

		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(203, 203, 203)
			}):Play()
		end)

		btn.MouseButton1Click:Connect(function()
			selectedMaterial = materialName
			dropdownBtn.Text = "Selected new material: " .. materialName
			task.delay(1, function()
				dropdownBtn.Text = "Open materials list"
			end)
			toggleDropdown()
		end)
	else
		warn("Invalid material: " .. materialName)
	end
end

-- Apply Button Click
applyButton.MouseButton1Click:Connect(function()
	local materialEnum = materialMap[selectedMaterial]
	if materialEnum then
		viewPart.Material = materialEnum
		changeMaterialRemote:FireServer(selectedMaterial)
		actualMaterial.Text = "Selected material: " .. selectedMaterial
		TweenService:Create(viewPart, TweenInfo.new(0.2), {Transparency = 1}):Play()
		task.wait(0.2)
		TweenService:Create(viewPart, TweenInfo.new(0.2), {Transparency = 0}):Play()
	else
		warn("Invalid material:", selectedMaterial)
	end
end)

-- Search Box
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local searchText = searchBox.Text:lower()
	local hasResults = false

	for _, button in ipairs(listFrame:GetChildren()) do
		if button:IsA("TextButton") and button.Name ~= "MaterialTemplate" then
			local match = button.Name:lower():find(searchText)
			button.Visible = match ~= nil
			if match then hasResults = true end
		end
	end

	nothingFoundLabel.Visible = not hasResults
end)

-- Recent Material Handling
local function addRecentMaterial(materialName)
	if #recentMaterials > 0 and recentMaterials[1] == materialName then return end

	for i = #recentMaterials, 1, -1 do
		if recentMaterials[i] == materialName then
			table.remove(recentMaterials, i)
			break
		end
	end

	table.insert(recentMaterials, 1, materialName)

	if #recentMaterials > MAX_RECENT then
		table.remove(recentMaterials)
	end

	updateRecentFrame()
end

function updateRecentFrame()
	for _, child in ipairs(recentFrame:GetChildren()) do
		if child:IsA("GuiButton") and child.Name ~= "TemplateMaterialButton" then
			child:Destroy()
		end
	end

	for i, materialName in ipairs(recentMaterials) do
		local newBtn = materialTemplate:Clone()
		newBtn.Visible = true
		newBtn.Parent = recentFrame
		newBtn.Name = "Material" .. i
		newBtn.Text = materialName

		newBtn.MouseEnter:Connect(function()
			TweenService:Create(newBtn, TweenInfo.new(0.2), {
				BackgroundTransparency = 0.1
			}):Play()
		end)

		newBtn.MouseLeave:Connect(function()
			TweenService:Create(newBtn, TweenInfo.new(0.2), {
				BackgroundTransparency = 0.5
			}):Play()
		end)

		newBtn.MouseButton1Click:Connect(function()
			local materialEnum = materialMap[materialName]
			if materialEnum then
				viewPart.Material = materialEnum
				selectedMaterial = materialName
				dropdownBtn.Text = "Open materials list"
				changeMaterialRemote:FireServer(materialName)
				actualMaterial.Text = "Selected material: " .. materialName
				TweenService:Create(viewPart, TweenInfo.new(0.2), {Transparency = 1}):Play()
				task.wait(0.2)
				TweenService:Create(viewPart, TweenInfo.new(0.2), {Transparency = 0}):Play()
			end
		end)
	end
end

-- Track changes to material on preview part
viewPart:GetPropertyChangedSignal("Material"):Connect(function()
	script.Parent.SelectedMaterialString.Value = viewPart.Material.Name
	addRecentMaterial(viewPart.Material.Name)
end)

-- Close Button Animations
closeButton.MouseEnter:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Size = UDim2.fromScale(0.085, 0.1525)
	}):Play()
end)

closeButton.MouseLeave:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Size = UDim2.fromScale(0.068, 0.122)
	}):Play()
end)

closeButton.MouseButton1Click:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.2, -1)}):Play()
end)
