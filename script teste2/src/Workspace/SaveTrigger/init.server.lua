--//Created by PlaasBoer 
--Version 3.3.0
--If you find a bug comment on my video for Zed's tycoon save
--Link to my channel 
--[[
	https://www.youtube.com/channel/UCHIypUw5-7noRfLJjczdsqw
]]--

local tycoonsFolder = script.Parent:WaitForChild("Tycoons")
local tycoons = tycoonsFolder:GetChildren()

--Delete it because the old one name PurchaseHandler will delete purchases before the new one
--called PurchaseHandlerNew can get to it.
for k = 1,#tycoons,1 do
	tycoons[k].PurchaseHandler:Destroy()
end
print("Latest-----------------2020/06/03")
local content = script:WaitForChild("Content")
content.PlayerStatManager.Parent = script.Parent

---Removing old core handler with new one
local coreHandler = script.Parent:WaitForChild("Core_Handler")
coreHandler:Destroy()
local coreHandlerNew = content:WaitForChild("Core_Handler_New")
local coreHandlerNewClone = coreHandlerNew:Clone()
coreHandlerNewClone.Parent = script.Parent
coreHandlerNewClone.Disabled = false
----------------------------------------------

local PlayerStatManager = require(script.Parent:WaitForChild("PlayerStatManager"))

local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local playerMoney = serverStorage:WaitForChild("PlayerMoney")
local purchaseHandlerNew = content.PurchaseHandlerNew
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local staterGui = game:GetService("StarterGui")

local allObjects = {}

local TycoonSettings = require(script.Parent.Settings)

local Settings = require(script.Settings)
local RebirthSettings = Settings.Rebirth
local TestSettings = Settings.Test

local rebirthEvent = content:WaitForChild("RebirthEvent (Don't Move)")
local touchAllTycoonButtons = content:WaitForChild("TouchAllTycoonButtons")
local giveCashEvent = content:WaitForChild("GiveCash")
local rebirthGui = content:WaitForChild("RebirthGui (Don't Move)")
local touchTycoonButtonsGui = content:FindFirstChild("TouchTycoonButtons")

rebirthEvent.Parent = replicatedStorage
if touchTycoonButtonsGui then
	if runService:IsStudio() or TestSettings.showTouchTycoonButtonsGuiOutsideStudio then
		touchAllTycoonButtons.Parent = replicatedStorage
		giveCashEvent.Parent = replicatedStorage
		touchTycoonButtonsGui.Parent = staterGui 
	else
		touchAllTycoonButtons:Destroy()
		giveCashEvent:Destroy()
		touchTycoonButtonsGui:Destroy()
	end
end
local AllTycoons = {}
for i,v in pairs(script.Parent:WaitForChild('Tycoons'):GetChildren()) do
	AllTycoons[v.Name] = v:Clone()
end

--Adding additional ignorePurchases because of the unlockPurchases setting that each button 
--has dependancies
local unlock = {}
local allButtons = tycoons[1].Buttons:GetChildren()
local unlockPurchases = RebirthSettings.unlockPurchases

function addDependencies(ignoreInner,obj)
	local queue = {}
	for t = 1,#allButtons,1 do
		local object = allButtons[t]:FindFirstChild("Object")
		local dependency = allButtons[t]:FindFirstChild("Dependency")
		if object ~= nil and dependency ~= nil then
			if dependency.Value == obj then
				table.insert(ignoreInner,object.Value)
				table.insert(queue,object.Value)
			end
		end
	end
	for d = 1,#queue,1 do
		addDependencies(ignoreInner,queue[d])
	end
end

for u = 1,#unlockPurchases,1 do
	unlock[u] = {rebirthCount = unlockPurchases[u].rebirthCount}
	table.insert(unlock[u],unlockPurchases[u].unlock)
	addDependencies(unlock[u],unlockPurchases[u].unlock)
end

function hideBillboadAndText(billboardGui, textLabel)
	if billboardGui then
		billboardGui.Enabled = false
		if textLabel then
			textLabel.TextTransparency = 1
		end
	end
end

function showBillboadAndText(billboardGui, textLabel)
	if billboardGui then
		billboardGui.Enabled = true
		if textLabel then
			textLabel.TextTransparency = 0
		end
	end
end

function hideButton(name,buttons)
	local allButtons = buttons:GetChildren()
	local item = nil
	for i = 1,#allButtons,1 do
		local hasObject = allButtons[i]:FindFirstChild("Object")
		if hasObject and hasObject:IsA("StringValue") and 
		   allButtons[i].Object.Value == name then
			item = allButtons[i]
			break
		end
	end
	if item ~= nil then
		local head = item:FindFirstChild("Head")
		if head ~= nil then
			local billboardGui = head:FindFirstChild("BillboardGui")
			local textLabel
			if billboardGui then
				textLabel = billboardGui:FindFirstChild("TextLabel")
			end
			if TycoonSettings['ButtonsFadeOut'] then
				head.CanCollide = false
				coroutine.resume(coroutine.create(function()
					for i=1,20 do
						wait(TycoonSettings['FadeOutTime']/20)
						head.Transparency = head.Transparency + 0.05
						if textLabel then
							textLabel.TextTransparency = textLabel.TextTransparency + 0.05
						end
					end
					
					hideBillboadAndText(billboardGui, textLabel)
				end))
			else
				head.CanCollide = false
				head.Transparency = 1
				hideBillboadAndText(billboardGui, textLabel)
			end
		end
	end
end

local function getTouchToClaimAndDeleteGateControl(nextTycoon)
	local gate = nextTycoon.Entrance:GetChildren()
	local touchToClaim = nil
	for i = 1,#gate, 1 do
		local gateControl = gate[i]:FindFirstChild("GateControl")
		if gateControl ~= nil then
			touchToClaim = gate[i]
			gateControl:Destroy()
			break
		end
	end
	if touchToClaim == nil then
		error("Zed's tycoon Save scripts make sure you have a script called 'GateControl' in each tycoons Entrance/Touch to claim!")
	end
	return touchToClaim
end

function loadPurchedObjectFromDatabaseIfPlayerTouchToClaim(touchToClaimHead,
															purchasedObjects,
															PurchaseHandlerNew,
															tycoon)
	--TODO all purhcases must have a button
	local purchases = tycoon:WaitForChild("Purchases")
	while true do
		wait(0.1)
		if #purchases:GetChildren() < 10 then break end
	end
	local debounce = true
	touchToClaimHead.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid ~= nil and humanoid.Health > 0 and debounce then
			local success,err = pcall(function() 
				local playerInPlayerMoney = playerMoney:FindFirstChild(humanoid.Parent.Name)
				local ownsTycoon = nil
				if playerInPlayerMoney ~= nil then
			   		 ownsTycoon = playerInPlayerMoney:FindFirstChild("OwnsTycoon")
				end
				if ownsTycoon ~= nil and ownsTycoon.Value == nil and not tycoon.Owner.Value then
					
					local player = game.Players:FindFirstChild(humanoid.Parent.Name)
					print("Before loading objects in tycoon for player ",player.Name)
					print("------------------------------")

					if player ~= nil then
						debounce = false
						tycoon.CurrencyToCollect.Value = 0
						touchToClaimHead.Transparency = 1
						tycoon.Owner.Value = player
						ownsTycoon.Value = tycoon
						touchToClaimHead.Parent.Name = player.Name.."'s Tycoon"
						touchToClaimHead.Transparency = 0.6
						
						touchToClaimHead.CanCollide = false
						player.TeamColor = tycoon.TeamColor.Value
						local data = PlayerStatManager:getPlayerData(player)["TycoonPurchases"]

						for key,value in pairs(PurchaseHandlerNew) do	
							print("Adding ",key)
							if data[key] == true then
								value.Parent = purchasedObjects
							end
						end	
						wait(2.5)
						for k,v in pairs(PurchaseHandlerNew) do
							if data[k] == true then
								local buttonName = k
								local buttons = tycoon.Buttons
								hideButton(buttonName,buttons)
							end
						end	
						if RebirthSettings.enabled == true then
							giveRebirthGuiIfTycoonFinished(PurchaseHandlerNew,player)
						end
					else
						print(" loadPurchedObjectFromDatabaseIfPlayerTouchToClaim Player == nil")	
					end
				else
					print("ownsTycoon.Value ~= nil or ownsTycoon == nil ")	
				end
				
			end)
			if success == false then
				print(err)
			end		
		end
		
	end)
end

function isTycoonFinished(PurchaseHandlerNew,player)
	local purchases = PlayerStatManager:getPlayerData(player)["TycoonPurchases"]
	local rebirthCountStat = PlayerStatManager:getStat(player,"RebirthCount")
	local playerHasTycoonObject = false
	--Checking what object should be ignored
	for key1,value1 in pairs(PurchaseHandlerNew) do
		local ignorePurchases = RebirthSettings.ignorePurchases
		local canContinue = true
		for i = 1,#ignorePurchases,1 do
			if ignorePurchases[i] == key1 then
				canContinue = false
				break
			end
		end
		--Check if it should ignore unlock purchases
		for u = 1,#unlock,1 do
			if rebirthCountStat < unlock[u].rebirthCount then
				for a = 1,#unlock[u],1 do
					if unlock[u][a] == key1 then
						canContinue = false
						break
					end
				end
			end
			if canContinue == false then
				break
			end
		end
	
		if canContinue then
			playerHasTycoonObject =  false
			for key2,value2 in pairs(purchases) do
				if value2 == true and key1 == key2 then
					playerHasTycoonObject = true
					break
				end
			end
			if playerHasTycoonObject == false then
				return false
			end
		end
	end
	return true
end

function giveRebirthGuiIfTycoonFinished(PurchaseHandlerNew,player)
	local hasFinishedTycoon = isTycoonFinished(PurchaseHandlerNew,player)
	if hasFinishedTycoon == true then
		local canRebirth = player:FindFirstChild("CanRebirth")
		if canRebirth ~= nil then
			canRebirth.Value = true
		end
		giveRebirthGui(player)
		
	end
end

function giveRebirthGui(player)
	local success,err = pcall(function() 
		local rebirthGuiClone = rebirthGui:Clone()
		local playerGui = player:FindFirstChild("PlayerGui")

		if playerGui ~= nil then
			--Added wait because after player died and their character is added
			--the gui does not get cloned only after I add wait
			wait(3)
			local hasRebirthGui = playerGui:FindFirstChild("RebirthGui (Don't Move)")
			if hasRebirthGui == nil then
				rebirthGuiClone.Parent = playerGui
			end
		else
			print("playerGui == nil")	
		end
	end)
	if success == false then
		print(err)
	end
end

function savePurchasesObjectsInDatabase(owner,instance,PurchaseHandlerNew)
	
	local status,err = pcall(function() 
		local player = owner.Value
		if player ~= nil then
			--local stat = PlayerStatManager:getStat(player,instance.Name)
			local stat = PlayerStatManager:getStatInTycoonPurchases(player,instance.Name)
			local statMoney = PlayerStatManager:getStat(player,"Money")

			if player ~= nil and not stat then
				PlayerStatManager:ChangeStatInTycoonPurchases(player, instance.Name, true)
				if RebirthSettings.enabled == true then
					giveRebirthGuiIfTycoonFinished(PurchaseHandlerNew,player)
				end
			end
		end
	end)
	if status == false then
		print(err)
	end
end

function playerJoinedCallFunction(player)
	local rebirthCountStat = PlayerStatManager:getStat(player,"RebirthCount")
	local plrJoinedOrDied = RebirthSettings.playerRespawned
	for i = 1,#plrJoinedOrDied,1 do
		if rebirthCountStat and rebirthCountStat >= plrJoinedOrDied[i].rebirthCount then
			plrJoinedOrDied[i][1](player)
		end
	end
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		if RebirthSettings.enabled == true then
			local canRebirth = player:FindFirstChild("CanRebirth")
			
			if canRebirth and canRebirth.Value == true then
				giveRebirthGui(player)
			end
			playerJoinedCallFunction(player)			
		end
	end)
end)

for i = 1,#tycoons,1 do
    --getTouchToClaimAndDeleteGateControl also destroys the gate
	local touchToClaim = getTouchToClaimAndDeleteGateControl(tycoons[i])
	
	purchaseHandlerNew:Clone().Parent = tycoons[i]

	local purchasedObjects = tycoons[i]:FindFirstChild("PurchasedObjects")
	local owner = tycoons[i]:FindFirstChild("Owner")
	local entrance = tycoons[i].Entrance
	local touchToClaimHead = touchToClaim.Head
	
	--Is PurchaseHandlerNew
	allObjects[i] = require(tycoons[i].PurchaseHandlerNew)
	
	--Load data
	--Check old code below long load data
	loadPurchedObjectFromDatabaseIfPlayerTouchToClaim(touchToClaimHead,
														purchasedObjects,
														allObjects[i],
														tycoons[i])
	
	--Save data
	if purchasedObjects ~= nil and owner ~= nil then
		purchasedObjects.ChildAdded:Connect(function(instance)
			--Check old code below long save data
			savePurchasesObjectsInDatabase(owner,instance,allObjects[i])
		end)
	else
		error("SaveTrigger script won't save data because either purchasedObjects or owner is NIL")
	end
end

tycoonsFolder.ChildAdded:Connect(function(tycoon)

	purchaseHandlerNew:Clone().Parent = tycoon
	local purchasedObjects = tycoon:FindFirstChild("PurchasedObjects")
	local owner = tycoon:FindFirstChild("Owner")
	
	local touchToClaim = getTouchToClaimAndDeleteGateControl(tycoon)
	
	local touchToClaimHead = touchToClaim.Head
	
	local PurchaseHandlerNew = require(tycoon.PurchaseHandlerNew)
	
	--Load data
	--Check old code below long load data
	loadPurchedObjectFromDatabaseIfPlayerTouchToClaim(touchToClaimHead,
													  purchasedObjects,
													  PurchaseHandlerNew,
													  tycoon)
	
	--Save data
	if purchasedObjects ~= nil and owner ~= nil then
		purchasedObjects.ChildAdded:Connect(function(instance)
			--Check old code below long save data
			savePurchasesObjectsInDatabase(owner,instance,PurchaseHandlerNew)
		end)
	else
		error("SaveTrigger script won't save data because either purchasedObjects or owner is NIL")
	end
end)

function getTycoonByPlayerName(playerName)
	local allTycoons = tycoonsFolder:GetChildren()
	for i = 1,#allTycoons,1 do
		local owner = allTycoons[i]:FindFirstChild("Owner")
		if owner ~= nil and allTycoons[i]:IsA("Model") then
			if owner.Value ~= nil and owner.Value.Name == playerName then
				return allTycoons[i]
			end
		else
			print("MAKE SURE EACH TYCOON HAS OWNER VALUE")	
		end
	end
	return nil
end

function removeTycoonAndAddOriginal(tycoon,playerName)
	local plrStats = game.ServerStorage.PlayerMoney:FindFirstChild(playerName)
	if plrStats ~= nil then
		plrStats.OwnsTycoon.Value = nil
	end
	if tycoon then

        --Holds the original tycoons
		local backup = AllTycoons[tycoon.Name]:Clone()
		tycoon:Destroy()
		wait()
		local currencyToCollect = backup:FindFirstChild("CurrencyToCollect")
		if currencyToCollect ~= nil then
			currencyToCollect.Value = 0
		else 
			print("currencyToCollect == nil ----------------------->")
		end
		backup.Parent=script.Parent.Tycoons
		
	end
end

function teleportCharacterToSuppliedPart(player,tycoon)
	local partName = RebirthSettings.teleportToo
	local part = tycoon:FindFirstChild(partName)

	if part and part:IsA("BasePart") then
		local character = player.Character
		if character then
			character:SetPrimaryPartCFrame(part.CFrame)
		end
	end
end

function callFunctionsIfRebirthIsReached(rebirthCountStat,player)
	local playerReachedRebirthCount = RebirthSettings.playerReachedRebirthCount

	for i = 1,#playerReachedRebirthCount do
		if playerReachedRebirthCount[i].rebirthCount == rebirthCountStat then
			playerReachedRebirthCount[i][1](player)
			break
		end
	end
end

local function getCashAmountByRebirthCount(array,rebirthCount)
	for key,value in pairs(array) do
		if value.rebirthCount == rebirthCount then
			return value.cashAmount
		end
	end
end

rebirthEvent.OnServerEvent:Connect(function(player)
	
	local rebirthCountStat = PlayerStatManager:getStat(player,"RebirthCount")
	--TODO real investigate if rebirth count can be nil
	if rebirthCountStat == nil then return end
	local array = RebirthSettings.cashNeededForRebirth 
	local cashNeeded = getCashAmountByRebirthCount(array,rebirthCountStat+1)
	local playerStats = game.ServerStorage.PlayerMoney:FindFirstChild(player.Name)
	
	if not cashNeeded then cashNeeded = RebirthSettings.defaultCashNeededForRebirth end
	
	if RebirthSettings.enabled == true then 
		if (playerStats.Value >= cashNeeded) == false then
			rebirthEvent:FireClient(player,cashNeeded)
			return
		end
		
		local success,err = pcall(function() 
			local ownsTycoon = playerStats:FindFirstChild("OwnsTycoon")
		
			if ownsTycoon ~= nil and ownsTycoon.Value ~= nil then
			
				local tycoon = getTycoonByPlayerName(player.Name);
				if tycoon ~= nil then
					local PurchaseHandlerNew = require(tycoon.PurchaseHandlerNew)
					local hasFinishedTycoon = isTycoonFinished(PurchaseHandlerNew,player)
					if hasFinishedTycoon == true then
					
						PlayerStatManager:setAllTycoonPurchasesToNil(player)
						
						if rebirthCountStat == nil then
							PlayerStatManager:saveStat(player,"RebirthCount",0)
						end
						if RebirthSettings.resetCash then
							PlayerStatManager:saveStat(player,"Money",0)
						end
						
						PlayerStatManager:IncrementStat(player,"RebirthCount",1)
						rebirthCountStat = PlayerStatManager:getStat(player,"RebirthCount")
						for u = 1,#unlockPurchases,1 do
							if rebirthCountStat >= unlockPurchases[u].rebirthCount then
								--TODO check if there is bugs
								PlayerStatManager:ChangeStatInTycoonPurchases(player, unlockPurchases[u].unlock, true)
							end
						end
						callFunctionsIfRebirthIsReached(rebirthCountStat,player)
						
						local leaderstats = player:FindFirstChild("leaderstats")
						if leaderstats ~= nil then
							local rebirths = leaderstats:FindFirstChild("Rebirths")
							local moneyStat = leaderstats:FindFirstChild("Money")
							if rebirths ~= nil and rebirthCountStat ~= nil then
								rebirths.Value = rebirthCountStat
							end
							if moneyStat ~= nil and RebirthSettings.resetCash then
								moneyStat.Value = 0
							end
						end
						
						local playerStats = game.ServerStorage.PlayerMoney:FindFirstChild(player.Name)
						if RebirthSettings.resetCash then
							playerStats.Value = 0
						end
						teleportCharacterToSuppliedPart(player,tycoon)
						removeTycoonAndAddOriginal(tycoon,player.Name)
						local canRebirth = player:FindFirstChild("CanRebirth")
						if canRebirth ~= nil then
							canRebirth.Value = false
						end
						local playerGui = player:FindFirstChild("PlayerGui")
						if playerGui ~= nil then
							local rebirthGui = playerGui:FindFirstChild("RebirthGui (Don't Move)")
							if rebirthGui ~= nil then
								rebirthGui:Destroy()
							end
						end
						
					end
				else
					print("Tycoon is nil getTycoonByPlayerName("..player.Name..")")	
				end
			end
		end)
		if success == false then
			print(err)
		end
	end
end)


if runService:IsStudio() or TestSettings.showTouchTycoonButtonsGuiOutsideStudio then
	local canContinueTouchingButtons = false
	
	touchAllTycoonButtons.OnServerEvent:Connect(function(player,start)
		canContinueTouchingButtons = start
		if canContinueTouchingButtons then
			local character = player.Character
			local tycoon = getTycoonByPlayerName(player.Name);
			if not tycoon then return end
			while canContinueTouchingButtons do 
				local allTheButtons = tycoon.Buttons:GetChildren();
				local notOpen = false
				for i = 1,#allTheButtons,1 do
					local head = allTheButtons[i]:FindFirstChild("Head")
					if not canContinueTouchingButtons then return end
					if head and head.Transparency == 0 then
						local headPos = head.Position
						local newPos = Vector3.new(headPos.X,headPos.Y+1.2,headPos.Z)
						character:MoveTo(newPos)
						wait(0.5)
						notOpen = true
					end
				end
				if notOpen == false then
					break
				end
			end
		end
	end)
	
	giveCashEvent.OnServerEvent:Connect(function(player,cashAmount)
		local plrCash = playerMoney:FindFirstChild(player.Name)
		if plrCash then
			plrCash.Value = plrCash.Value + cashAmount
		end
	end)
end

--while wait(59) do
--	pcall(function()
--		local allPlayers = players:GetChildren()
--		for i = 1,#allPlayers,1 do
--			if allPlayers[i] ~= nil then
--				local playersMoneyChild = playerMoney:FindFirstChild(allPlayers[i].Name)
--				if playersMoneyChild then
--					PlayerStatManager:saveStat(allPlayers[i], "Money", playersMoneyChild.Value)
--				end
--			end
--		end
--	end)
--end

	
--	local gateControlNewClone = gateControlNew:Clone()
--	gateControlNewClone.Parent = touchToClaim
--	gateControlNewClone.Disabled = false
			
		--local gateControlNewClone = gateControlNew:Clone()
		--gateControlNewClone.Parent = touchToClaim
		--gateControlNewClone.Disabled = false

--	for i = 1,#allButtons,1 do
--		local object = allButtons[i]:FindFirstChild("Object")
--		local dependency = allButtons[i]:FindFirstChild("Dependency")
--		if object ~= nil and dependency ~= nil then
--			if dependency.Value == unlockPurchases[u][1] then
--				table.insert(ignore[u],object.Value)
--				scanForDependenceis(ignore[u],object.Value)
--			end
--		end
--	end

--function playerDiedCallFunction(player)
--	local rebirthCountStat = PlayerStatManager:getStat(player,"RebirthCount")
--	local plrJoinedOrDied = RebirthSettings.Rebirth.playerJoinedOrDied
--	for i = 1,#plrJoinedOrDied,1 do
--		if rebirthCountStat >= plrJoinedOrDied[i].rebirthCount
--		and plrJoinedOrDied[i].recallOnDeath == true then
--			plrJoinedOrDied[i][1](player)
--		end
--	end
--end

--			character.Humanoid.Died:Connect(function()
--				playerDiedCallFunction(player)
--			end)


--tycoonsFolder.ChildAdded:Connect(function(tycoon)

	--local purchaseHandler = tycoon:FindFirstChild("PurchaseHandler")
	--if purchaseHandler ~= nil then
		--purchaseHandler:Destroy()
		--purchaseHandlerNew:Clone().Parent = tycoon