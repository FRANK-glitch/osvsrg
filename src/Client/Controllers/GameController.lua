-- Game Controller
-- kisperal 
-- August 14, 2020

local HttpService = game:GetService("HttpService")

local GameController = {}

local ScreenWrapper

function GameController:Start()
	
end


function GameController:Init()
	local Roact:Roact = self.Shared.Roact
	local RoactRodux = self.Shared.RoactRodux

	local ComponentUtil = self.Modules.Utils.Roact.Component

	local screens = self.Modules.Screens

	screens = {
		screens.MainMenuScreen;
		screens.SongSelectScreen;
	}

	local wrappedScreens = {}

	for i, v in pairs(screens) do
		wrappedScreens[i] = Roact.createElement(ComponentUtil:Wrap(v, i, true))
	end

	local gui: RoactElement = Roact.createElement("ScreenGui", {}, wrappedScreens)

	local tree: RoactElement = Roact.createElement(RoactRodux.StoreProvider, {
		store = self.Controllers.StateController.RoduxStore
	}, {
		GameUI=gui;
	})

	Roact.mount(tree, self.Player.PlayerGui)
end


return GameController