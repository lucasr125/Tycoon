--//Created by PlaasBoer
-- Set up table to return to any script that requires this module script
local PlayerStatManager = {}

--Old never do it like this because child of Tycoons get deleted the the child children is empty causes bug
--local tycoons = script.Parent:WaitForChild("Tycoons"):GetChildren()

local Tycoons = script.Parent:WaitForChild("Tycoons")
local serverStorage = game:GetService("ServerStorage")
local runService = game:GetService("RunService")

local DataStoreService = game:GetService("DataStoreService")
local SaveSettings = require(script.Parent.SaveTrigger.Settings).Save

local playerData = DataStoreService:GetDataStore(SaveSettings.databaseName)

-- Table to hold player information for the current session
local sessionData = {}

local AUTOSAVE_INTERVAL = 60
if runService:IsStudio() then
	AUTOSAVE_INTERVAL = 15
end
--Not in use but keep here
--[[
function waitForTycoonsPurchaseHandlerNew()
	local tycoons = Tycoons:GetChildren()
	if tycoons[1]then
		if #tycoons[1]:WaitForChild("Purchases"):GetChildren() <= 10 then
			local purchaseHandlerNew = tycoons[1]:FindFirstChild("PurchaseHandlerNew")
			if purchaseHandlerNew ~= nil then
				return purchaseHandlerNew
			else
				wait(0.1)
				return waitForTycoonsPurchaseHandlerNew()
			end
		else
			wait(0.1)
			return waitForTycoonsPurchaseHandlerNew()
		end
	else
		wait(0.1)
		return waitForTycoonsPurchaseHandlerNew()
	end
end

local savedPurchasesNames = {} 
spawn(function()
	local purchaseHandlerNew = waitForTycoonsPurchaseHandlerNew()
	local Objects = require(purchaseHandlerNew)
	--Adding purchases names for saves
	for key,value in pairs(Objects) do
		table.insert(savedPurchasesNames,value.Name)	
	end
end)
]]--

-- Function that other scripts can call to change a player's stats
function PlayerStatManager:ChangeStat(player, statName, value)
	local playerUserId = "Player_" .. player.UserId
	sessionData[playerUserId][statName] = value
end

function PlayerStatManager:ChangeStatInTycoonPurchases(player, statName, value)
	local playerUserId = "Player_" .. player.UserId
	sessionData[playerUserId]["TycoonPurchases"][statName] = value
	print("Saving------------------> ",statName)
end

function PlayerStatManager:IncrementStat(player, statName, value)
	local playerUserId = "Player_" .. player.UserId
	if typeof(sessionData[playerUserId][statName]) == "number" then
		sessionData[playerUserId][statName] = sessionData[playerUserId][statName] + value
	end
end


local function setupPlayerData(player)	
	local playerMoney = serverStorage:WaitForChild("PlayerMoney")
	local playerStats = playerMoney:FindFirstChild(player.Name)
	--Sometimes people have duplicate tycoon add e.g in core handler script
	--adds PlayerMoney to storage and number value with player name that holds the 
	--money value 
	if playerStats == nil then
		playerStats = Instance.new("NumberValue",playerMoney)
		playerStats.Name = player.Name
		local isOwner = Instance.new("ObjectValue",playerStats)
		isOwner.Name = "OwnsTycoon"
	end
	local playerUserId = "Player_" .. player.UserId
 
	local success,data = pcall(function()
		return playerData:GetAsync(playerUserId)
	end)
	
	if success then
		if data then
			print("----------Money: ---------> "..data["Money"])
			print("Show tycoon purchases---------------------")
			sessionData[playerUserId] = data
			for key,value in pairs(sessionData[playerUserId]["TycoonPurchases"]) do
				print(key,value)
			end
			print("End printing tycoon purchases-------------")
			
			local playerMoneyChild = playerMoney:FindFirstChild(player.Name)
			if playerMoneyChild then
				playerMoneyChild.Value = playerMoneyChild.Value + data["Money"]
			else print("------------playerMoneyChild is nil") end
			
		else
			print("setupPlayerData no data found for player ",player.Name)	
			wait()
			local money = 0
			local success,err = pcall(function()
				if player:IsInGroup(SaveSettings.giveCashToPlayersInGroup.groupId) then
					local plrCash = playerMoney:FindFirstChild(player.Name)
					if plrCash then
						plrCash.Value = plrCash.Value + SaveSettings.giveCashToPlayersInGroup.cashAmount
						money = plrCash.Value	
					end
				end
			end)
			
			if success == false then
				print(err)
			end
			
			sessionData[playerUserId] = {}
			sessionData[playerUserId]["Money"] = money
			sessionData[playerUserId]["RebirthCount"] = 0
			sessionData[playerUserId]["TycoonPurchases"] = {}
		end	
		playerStats.Changed:Connect(function(newValue) 
			print("playerStats.Changed ",newValue)
			sessionData[playerUserId]["Money"] = newValue
		end)
	else
		warn("Couldn't get data")
		print(data)
	end		
end
 
-- Function to save player's data
local function savePlayerData(playerUserId)
	if sessionData[playerUserId] then
		local success,data = pcall(function()
			--NOTE!!! adding this print adds save if remove then save is lost
			print("Money --> before SetAsync ",sessionData[playerUserId]["Money"])
			playerData:SetAsync(playerUserId, sessionData[playerUserId])
			print("Money --> After SetAsync ",sessionData[playerUserId]["Money"])
			wait()
		end)
		if not success then
			warn("Cannot save data for player!-------------------------------------->")
			warn("----------------------savePlayerData----------------------------------------------")
			warn("What is the reason ",data)
		end
	end
end

function PlayerStatManager:getPlayerData(player)
	local playerUserId = "Player_" .. player.UserId
	local succes,data = pcall(function() 
		print("Got player data---------------------->")
		return sessionData[playerUserId]
	end)
	if succes == false then
		warn("ERROR---------PlayerStatManager:getPlayerData----------->")
		print(data)
		return nil
	else
		return data	
	end
	
end 

function PlayerStatManager:getStat(player,statName)
	local succes,data = pcall(function() 
		local playerUserId = "Player_" .. player.UserId
		return sessionData[playerUserId][statName]
	end)
	if succes == false then
		warn("ERROR---------PlayerStatManager:getStat----------->")
		print(data)
		return nil
	else
		return data	
	end
end 

function PlayerStatManager:saveStat(player,statName,value)
	local succes,err = pcall(function() 
		local playerUserId = "Player_" .. player.UserId
		sessionData[playerUserId][statName] = value
	end)
	if succes == false then
		warn("ERROR---------PlayerStatManager:saveStat----------->")
		print(err)
	end
end 

function PlayerStatManager:getStatInTycoonPurchases(player,statName)
	local succes,data = pcall(function() 
		local playerUserId = "Player_" .. player.UserId
		return sessionData[playerUserId]["TycoonPurchases"][statName]
	end)
	if succes == false then
		warn("ERROR---------PlayerStatManager:getTycoonPurchases----------->")
		print(data)
		return nil
	else
		return data	
	end
end 

function PlayerStatManager:setPlayerSessionDataToNil(player)
	if player ~= nil then
		local playerUserId = "Player_" .. player.UserId
		if sessionData[playerUserId] then
			sessionData[playerUserId] = nil
		end
	end
end

-- Function to save player data on exit
function PlayerStatManager:saveOnExit(player)
	local success,err = pcall(function()
		local playersMoney = serverStorage.PlayerMoney:FindFirstChild(player.Name)
		if playersMoney ~= nil then
			--print("--------------playersMoney.Value = "..playersMoney.Value)
			PlayerStatManager:saveStat(player, "Money", playersMoney.Value)
		else
			print("playersMoney is nil")
		end
		local playerUserId = "Player_" .. player.UserId
		savePlayerData(playerUserId)
	end)
	if success == false then
		warn("ERROR---------PlayerStatManager:saveOnExit----------->")
		print(err)
	end
end
 
function PlayerStatManager:setAllTycoonPurchasesToNil(player)
	local playerUserId = "Player_" .. player.UserId
	local data = sessionData[playerUserId]["TycoonPurchases"]
	for key,value in pairs(data) do
		sessionData[playerUserId]["TycoonPurchases"][key] = nil 
	end
end
-- Function to periodically save player data
local function autoSave()
	while wait(AUTOSAVE_INTERVAL) do
		print("Saving")
		for playerUserId, data in pairs(sessionData) do
			savePlayerData(playerUserId)
		end
	end
end
 
-- Start running 'autoSave()' function in the background
spawn(autoSave)
 
-- Connect 'setupPlayerData()' function to 'PlayerAdded' event
game.Players.PlayerAdded:Connect(setupPlayerData)

return PlayerStatManager



--Graveyard---------------
--[[

--function PlayerStatManager:getTycoonPurchases(player)
--	local succes,data = pcall(function() 
--		local playerUserId = "Player_" .. player.UserId
--		return sessionData[playerUserId]["TycoonPurchases"]
--	end)
--	if succes == false then
--		warn("ERROR---------PlayerStatManager:getTycoonPurchases----------->")
--		print(data)
--		return nil
--	else
--		return data	
--	end
--end 
local function setupPlayerData(player)	
	local playerMoney = serverStorage:WaitForChild("PlayerMoney")
	local playerStats = playerMoney:FindFirstChild(player.Name)
	--Sometimes people have duplicate tycoon add e.g in core handler script
	--adds PlayerMoney to storage and number value with player name that holds the 
	--money value 
	if playerStats == nil then
		local plrStats = Instance.new("NumberValue",playerMoney)
		plrStats.Name = player.Name
		local isOwner = Instance.new("ObjectValue",plrStats)
		isOwner.Name = "OwnsTycoon"
	end
	local playerUserId = "Player_" .. player.UserId
 
	local success,data = pcall(function()
		return playerData:GetAsync(playerUserId)
	end)
	
	if success then
		if data then
			print("----------Money: ---------> "..data["Money"])

			sessionData[playerUserId] = data
			local playerMoneyChild = playerMoney:FindFirstChild(player.Name)
			if playerMoneyChild then
				playerMoneyChild.Value = playerMoneyChild.Value + data["Money"]
			else
				print("------------playerMoneyChild is nil")
			end
		else
			print("No data----------------->")
			
			wait()
			local success,err = pcall(function()
				if player:IsInGroup(groupId) then
					local cashmoney = playerMoney:FindFirstChild(player.Name)
					if cashmoney then
						cashmoney.Value = cashmoney.Value + cashGivenAmount
					end
				end
			end)
			
			if success == false then
				print(err)
			end
			
			sessionData[playerUserId] = {}
			--Adding purchases names to player saves but false
			for f = 1,#savedPurchasesNames,1 do
				local name = savedPurchasesNames[f]
				sessionData[playerUserId][name] = false
			end
			
			sessionData[playerUserId]["Money"] = cashGivenAmount
			sessionData[playerUserId]["RebirthCount"] = 0
			return
		end

		--Adding new version objects
		for e = 1,#savedPurchasesNames,1 do
			local name = savedPurchasesNames[e]
			print("Name of object: ",name)
			if sessionData[playerUserId][name] == nil then
				print("Adding new version objects "..name)
				sessionData[playerUserId][name] = false
			end
		end]
		
	else
		warn("Couldn't get data")
		print(data)
	end		
end
]]--

		--Testing wait TODO remove
		--TODO fix problem PurchaseHandlerNew add objects from purchases while it is being
		--required below and the it doesn't add new version for player if he joins the first initiolization
		--of the server
		--wait(5)--delete later on --if must turn back on uncomment this
		--Investigate
		--local purchaseHandlerNew = waitForTycoonsPurchaseHandlerNew()
		--local Objects = require(purchaseHandlerNew)
		--print("Name of tycoon: ",tycoons[1].Name)
		--local Objects = require(tycoons[1]:WaitForChild("PurchaseHandlerNew"))
	   

		--Adding new version objects
--		for key,value in pairs(Objects) do
--			print("Name of object: ",key)
--			if sessionData[playerUserId][key] == nil then
--				print("Adding new version objects "..key)
--				sessionData[playerUserId][key] = false
--			end
--		end
--			for key,value in pairs(Objects) do
--				--print("Adding object "..key)
--				sessionData[playerUserId][key] = false
--			end	
			--Investigate
			--local purchaseHandlerNew = waitForTycoonsPurchaseHandlerNew()
			--local Objects = require(purchaseHandlerNew)
			--local Objects = require(tycoons[1]:WaitForChild("PurchaseHandlerNew"))
			
--			for key,value in pairs(sessionData[playerUserId]) do
--				print("Getting object "..key)
--				print(value)
--			end	
			-- Data exists for this player
			-- Data store is working, but no current data for this player

--function PlayerStatManager:setAllStatsToFalseExcept(player,exception)
--	local playerUserId = "Player_" .. player.UserId
--	local data = sessionData[playerUserId]
--	for key,value in pairs(data) do
--		if key ~= exception then
--			sessionData[playerUserId][key] = false 
--		end
--	end
--end