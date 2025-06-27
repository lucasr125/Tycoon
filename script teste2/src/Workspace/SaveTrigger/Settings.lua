
local Settings = {
		 ['Save'] = {
			['databaseName'] = "ZednovTycoon101", --Change to have new saves --original name ZednovTycoon101
			
			['giveCashToPlayersInGroup'] = { --Will only be given once to new players if they joined the group
				['groupId'] = 5944189, --Id of the group they must join to get cash
				['cashAmount'] = 0  --The amount of cash they will get
			}
		 },
		 
		 ['Test'] = {
			['showTouchTycoonButtonsGuiOutsideStudio'] = false --Of true will show it when someone plays your game outside studio
		 },     
	
         ['Rebirth'] = {
            ['enabled'] = true,
		['ignorePurchases'] = {"NameOfPurchase1","PurchaseName","NameOfAPurchase",},
            ['resetCash'] = true,
  
			['teleportToo'] = "TeleportPart", --Name of part here but part must be inside each tycoon
			
			['unlockPurchases'] = {
				{rebirthCount = 1,unlock = "rebirth1"},
				{rebirthCount = 2,unlock = "rebirth2"},
				{rebirthCount = 3,unlock = "rebirth3"}
			},
			
			['defaultCashNeededForRebirth'] = 0,
			['cashNeededForRebirth'] = {
				{rebirthCount = 1,cashAmount = 0},
				{rebirthCount = 2,cashAmount = 50000}
			},
			
		    ['playerRespawned'] = { --Will execute after player spawned
				{
					rebirthCount = 1,
					function(player) 
						--player.Character.Humanoid.WalkSpeed = 35
						--code here to execute if player reached the rebirthCount or above.
					end
				},
				{
					rebirthCount = 2,
					function(player) 
						--player.Character.Head.Transparency = 1
						--code here to execute if player reached the rebirthCount or above.
					end
				}
		    },
		
		   ['playerReachedRebirthCount'] = { --Will only run one time
				{
					rebirthCount = 1,
					function(player) 
						--code here to execute only once if player reached the rebirthCount.
					end
				},
				{
					rebirthCount = 2,
					function(player) 
						--code here to execute only once if player reached the rebirthCount.
					end
				}
		  }
		
     }
}

return Settings

