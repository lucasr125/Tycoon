--//Created by PlaasBoer
--Current Version 3.2.0
--[[
	Put SaveTrigger script inside your Zednov's Tycoon Kit Model.
	That's it.
	Go to settings if you want to change stuff.
	You can turn the Rebirth of by ['enabled'] = false,

	--MUST READ------------
		Why does my cash not save?
			Did you put it in the correct place.
		Note!
			This scripts I created does not save tycoons with different objects inside them
			so all tycoons must have the same objects inside.
			Gamepass buttons work.
			Developer products should not be used because it doesn't work as it should.
		Reasons why you tycoon is not working?
			You have duplicate SaveTrigger.
	-----------------------	
	
	--Version Track
		Version 1.0.0
		Save script for tycoon saves money and progress

	--Date 2020/02/02------------
		Version 2.0.0
		Added Rebirth with rebirth count after you finished tycoon you can click rebirth button
		then you money will reset and the tycoon reset and you will get rebirth count.

	--Date 
		Version 3.1.0	

	--Date 2021/01/07------------
		Version 3.2.0
		Fixed the gamepass buttons to work. (Don't use developer products in this version)
		Getting cash at start Fix for group even if your not in the group
		Fixed Cash problem not saving optimally.
	----------------------------------
--]]

script:Destroy()