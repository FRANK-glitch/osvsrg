-- Game Server Service
-- kisperal 
-- August 15, 2020



local GameServerService = {Client = {}}


function GameServerService:Start()
	
end


function GameServerService:Init()
	game.Players.CharacterAutoLoads = false
end


return GameServerService