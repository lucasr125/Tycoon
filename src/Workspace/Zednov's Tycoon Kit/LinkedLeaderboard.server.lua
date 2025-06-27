-- // Removed CTF Mode + Loads faster

local Settings = require(script.Parent.Settings)
script.Parent = game.ServerScriptService

function onHumanoidDied(humanoid, player)
	local stats = player:findFirstChild("leaderstats")
	if stats ~= nil then
		local deaths = stats:findFirstChild(Settings.LeaderboardSettings.DeathsName)
		if deaths then
			deaths.Value = deaths.Value + 1
		end
		if Settings.LeaderboardSettings.KOs then
			local killer = getKillerOfHumanoidIfStillInGame(humanoid)
			handleKillCount(humanoid, player)
		end
	end
end

function onPlayerRespawn(property, player)
	if property == "Character" and player.Character ~= nil then
		local humanoid = player.Character.Humanoid
		local p = player
		local h = humanoid
		if Settings.LeaderboardSettings.WOs then
			humanoid.Died:Connect(function() onHumanoidDied(h, p) end )
		end
	end
end

function getKillerOfHumanoidIfStillInGame(humanoid)
	local tag = humanoid:findFirstChild("creator")
	if tag ~= nil then
		local killer = tag.Value
		if killer.Parent ~= nil then
			return killer
		end
	end
	return nil
end

function handleKillCount(humanoid, player)
	local killer = getKillerOfHumanoidIfStillInGame(humanoid)
	if killer ~= nil then
		local stats = killer:findFirstChild("leaderstats")
		if stats ~= nil then
			local kills = stats:findFirstChild(Settings.LeaderboardSettings.KillsNames)
			if kills then
				if killer ~= player then
					kills.Value = kills.Value + 1	
				else
					kills.Value = kills.Value - 1
				end
			else
				return
			end
		end
	end
end

function onPlayerEntered(newPlayer)
	local stats = Instance.new("IntValue")
	stats.Name = "leaderstats"
	
	local ownedtycoon = Instance.new("ObjectValue")
	ownedtycoon.Name = "ownedtycoon"
	
	local kills = false
	if Settings.LeaderboardSettings.KOs then
		kills = Instance.new("IntValue")
		kills.Name = Settings.LeaderboardSettings.KillsName
		kills.Value = 0
	end
	
	local deaths = false
	if Settings.LeaderboardSettings.WOs then
		deaths = Instance.new("IntValue")
		deaths.Name = Settings.LeaderboardSettings.DeathsName
		deaths.Value = 0
	end
	
	local cash = false
	if Settings.LeaderboardSettings.ShowCurrency then
		cash = Instance.new("StringValue")
		cash.Name = Settings.CurrencyName
		cash.Value = 0
	end
	
	local PlayerStats = game.ServerStorage.PlayerMoney:FindFirstChild(newPlayer.Name)
	if PlayerStats ~= nil then
		if cash then
			local Short = Settings.LeaderboardSettings.ShowShortCurrency
			PlayerStats.Changed:Connect(function()
				if (Short) then
					cash.Value = Settings:ConvertShort(PlayerStats.Value)
				else
					cash.Value = Settings:ConvertComma(PlayerStats.Value)
				end
			end)
		end
	end
	
	if kills then
		kills.Parent = stats
	end
	if deaths then
		deaths.Parent = stats
	end
	if cash then
		cash.Parent = stats
	end
	
	while true do
		if newPlayer.Character ~= nil then break end
		task.wait()
	end
	
	local humanoid = newPlayer.Character.Humanoid
	humanoid.Died:Connect(function()
		onHumanoidDied(humanoid, newPlayer)
	end)
	newPlayer.Changed:Connect(function(property)
		onPlayerRespawn(property, newPlayer)
	end)
	stats.Parent = newPlayer
	ownedtycoon.Parent = newPlayer
end
game.Players.ChildAdded:Connect(onPlayerEntered)