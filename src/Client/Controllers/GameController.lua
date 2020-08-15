-- Game Controller
-- kisperal 
-- August 14, 2020



local GameController = {}

local ScreenWrapper

function GameController:Start()
	repeat wait() until self.Player.Character ~= nil
	local character = self.Player.Character
	character:Destroy()
	self.Player.Character = nil
end


function GameController:Init()
	local Roact:Roact = self.Shared.Roact

	local ComponentUtil = self.Modules.Utils.Roact.Component

	local MainMenuScreen = self.Modules.Screens.MainMenuScreen

	

	local tree: RoactElement = Roact.createElement("ScreenGui", {}, {
		MMS = Roact.createElement(ComponentUtil:Wrap(MainMenuScreen))
	})

	Roact.mount(tree, self.Player.PlayerGui)
end


return GameController