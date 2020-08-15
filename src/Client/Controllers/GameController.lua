-- Game Controller
-- kisperal 
-- August 14, 2020



local GameController = {}

local ScreenWrapper

function GameController:Start()
	
end


function GameController:Init()
	local Roact:Roact = self.Shared.Roact
	--[[
	local tree:RoactElement = Roact.createElement("ScreenGui", {}, {
		MMS = Roact.createElement(self.Modules.Screens.MainMenuScreen)
	})

	Roact.mount(tree, game.Players.LocalPlayer.PlayerGui)
	]]--
	print(self.Shared.StringUtil.RandomString(10))
end


return GameController