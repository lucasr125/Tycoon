local MarketplaceService = game:GetService("MarketplaceService")

local Objects = {}
local TeamColor = script.Parent.TeamColor.Value
local Settings = require(script.Parent.Parent.Parent.Settings)
local Money = script.Parent.CurrencyToCollect
local Debris = game:GetService('Debris')
local Stealing = Settings.StealSettings
local CanSteal = true -- don't change or else you won't be able to steal currency

script.Parent.Essentials.Spawn.TeamColor = TeamColor
script.Parent.Essentials.Spawn.BrickColor = TeamColor

function Sound(part,id)
	if part:FindFirstChild('Sound') then
		return
	else
		local Sound = Instance.new('Sound',part)
		Sound.SoundId = "rbxassetid://"..tostring(id)
		Sound:Play()
		task.delay(Sound.TimeLength, function()
			Sound:Destroy()
		end)
	end
end

--Parts that fall into the collector(s) get processed
for i,v in pairs(script.Parent.Essentials:GetChildren()) do
	if v.Name == "PartCollector" then
		v.Touched:Connect(function(Part)
			local AutoCollector = script.Parent.AutoCollector.Value
			if Part:FindFirstChild('Cash') then
				Money.Value = Money.Value + Part.Cash.Value
				Debris:AddItem(Part,0.1)
			end
		end)
	end
end

--Player Touched Collector processor
deb = false
script.Parent.Essentials.Giver.Touched:connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player ~= nil then
		if script.Parent.Owner.Value == player then
			if hit.Parent:FindFirstChild("Humanoid") then
				if hit.Parent.Humanoid.Health > 0 then
					if deb == false then
						deb = true
						script.Parent.Essentials.Giver.BrickColor = BrickColor.new("Bright red")
						local Stats = game.ServerStorage.PlayerMoney:FindFirstChild(player.Name)
						if Stats ~= nil then 
							Sound(script.Parent.Essentials, Settings.Sounds.Collect)
							Stats.Value = Stats.Value + Money.Value
							Money.Value = 0
							task.wait(1)
							script.Parent.Essentials.Giver.BrickColor = BrickColor.new("Sea green")
							deb = false
						end
					end
				end
			end
		elseif Stealing.Stealing then -- if player isn't owner and stealing is on
			if CanSteal == true then
				CanSteal = false
				task.delay(Stealing.PlayerProtection, function()
					CanSteal = true
				end)
				if hit.Parent:FindFirstChild("Humanoid") then
					if hit.Parent.Humanoid.Health > 0 then
						local Stats = game.ServerStorage.PlayerMoney:FindFirstChild(player.Name)
						if Stats ~= nil then
							local Difference = math.floor(Money.Value * Stealing.StealPrecent)
							Sound(script.Parent.Essentials, Settings.Sounds.Collect)
							Stats.Value = Stats.Value + Difference
							Money.Value = Money.Value - Difference
						end
					end
				end
			else
				Sound(script.Parent.Essentials, Settings.Sounds.Error)
			end
		end
	end
end)


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

local chosenGamePassButton = nil

script.Parent:WaitForChild("Buttons")
for i,v in pairs(script.Parent.Buttons:GetChildren()) do
	spawn(function()
		if v:FindFirstChild("Head") then
			local billboardGui = v.Head:FindFirstChild("BillboardGui")
			local textLabel
			if billboardGui then
				textLabel = billboardGui:FindFirstChild("TextLabel")
			end
			local ThingMade = script.Parent.Purchases:WaitForChild(v.Object.Value)
			if ThingMade ~= nil then
				--print("adding------------------> purchase ",ThingMade.Name)
				Objects[ThingMade.Name] = ThingMade:Clone()
				ThingMade:Destroy()
			else
				--//Button doesn't have object, remove it
				error('Object missing for button: '..v.Name..', button has been removed')
				v.Head.CanCollide = false
				v.Head.Transparency = 1
				hideBillboadAndText(billboardGui, textLabel)
			end

			if v:FindFirstChild("Dependency") then --// if button needs something unlocked before it pops up
				v.Head.CanCollide = false
				v.Head.Transparency = 1

				hideBillboadAndText(billboardGui, textLabel)

				coroutine.resume(coroutine.create(function()
					if script.Parent.PurchasedObjects:WaitForChild(v.Dependency.Value) then
						if Settings['ButtonsFadeIn'] then
							for i=1,20 do
								task.wait(Settings['FadeInTime']/20)
								v.Head.Transparency = v.Head.Transparency - 0.05
								if textLabel then
									textLabel.TextTransparency = textLabel.TextTransparency - 0.05
								end
							end

							showBillboadAndText(billboardGui, textLabel)
						end
						v.Head.CanCollide = true
						v.Head.Transparency = 0
						showBillboadAndText(billboardGui, textLabel)
					end
				end))
			end

			v.Head.Touched:connect(function(hit)
				local player = game.Players:GetPlayerFromCharacter(hit.Parent)
				if v.Head.CanCollide == true then
					if player ~= nil then
						if script.Parent.Owner.Value == player then
							if hit.Parent:FindFirstChild("Humanoid") then
								if hit.Parent.Humanoid.Health > 0 then
									local PlayerStats = game.ServerStorage.PlayerMoney:FindFirstChild(player.Name)
									if PlayerStats ~= nil then
										if (v:FindFirstChild('Gamepass')) and (v.Gamepass.Value >= 1) then
											if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId,v.Gamepass.Value) then
												Purchase({[1] = v.Price.Value,[2] = v,[3] = PlayerStats})
											else
												chosenGamePassButton = v
												game:GetService('MarketplaceService'):PromptGamePassPurchase(player,v.Gamepass.Value)
											end
										elseif (v:FindFirstChild('DevProduct')) and (v.DevProduct.Value >= 1) then
											game:GetService('MarketplaceService'):PromptProductPurchase(player,v.DevProduct.Value)
										elseif PlayerStats.Value >= v.Price.Value then
											Purchase({[1] = v.Price.Value,[2] = v,[3] = PlayerStats})
											Sound(v, Settings.Sounds.Purchase)
										else
											Sound(v, Settings.Sounds.ErrorBuy)
										end
									end
								end
							end
						end
					end
				end
			end)
		end
	end)
end


local function onPromptGamePassPurchaseFinished(player, purchasedPassID, purchaseSuccess)
	local PlayerStats = game.ServerStorage.PlayerMoney:FindFirstChild(player.Name)
	if purchaseSuccess == true and chosenGamePassButton and purchasedPassID == chosenGamePassButton.Gamepass.Value then
		print(player.Name .. " purchased the game pass with ID " .. chosenGamePassButton.Gamepass.Value)
		Purchase({[1] = chosenGamePassButton.Price.Value,[2] = chosenGamePassButton,[3] = PlayerStats})
	end
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptGamePassPurchaseFinished)


function Purchase(tbl)
	local cost = tbl[1]
	local item = tbl[2]
	local stats = tbl[3]
	stats.Value = stats.Value - cost
	Objects[item.Object.Value].Parent = script.Parent.PurchasedObjects
	local billboardGui = item.Head:FindFirstChild("BillboardGui")
	local textLabel
	if billboardGui then
		textLabel = billboardGui:FindFirstChild("TextLabel")
	end
	if Settings['ButtonsFadeOut'] then
		item.Head.CanCollide = false
		coroutine.resume(coroutine.create(function()
			for i=1,20 do
				task.wait(Settings['FadeOutTime']/20)
				item.Head.Transparency = item.Head.Transparency + 0.05
				if textLabel then
					textLabel.TextTransparency = textLabel.TextTransparency + 0.05
				end
			end
			hideBillboadAndText(billboardGui, textLabel)
		end))
	else
		item.Head.CanCollide = false
		item.Head.Transparency = 1
		hideBillboadAndText(billboardGui, textLabel)
	end
end

function Create(tab)
	local x = Instance.new('Model')
	Instance.new('NumberValue',x).Value = tab[1]
	x.Value.Name = "Cost"
	Instance.new('ObjectValue',x).Value = tab[2]
	x.Value.Name = "Button"
	local Obj = Instance.new('ObjectValue',x)
	Obj.Name = "Stats"
	Obj.Value = tab[3]
	x.Parent = script.Parent.BuyObject
end

--// This was very rushed and is inefficent; if you plan on making something like this don't use a child added listener.
script.Parent:WaitForChild('BuyObject').ChildAdded:connect(function(child)
	local tab = {}
	tab[1] = child.Cost.Value
	tab[2] = child.Button.Value
	tab[3] = child.Stats.Value
	Purchase(tab)
	task.wait(10)
	child:Destroy()
end)

return Objects