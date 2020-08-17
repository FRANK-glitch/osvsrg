-- Game Controller
-- kisperal 
-- August 14, 2020

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local GameController = {}

local ScreenWrapper

function GameController:Start()
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

	local song = self.Modules.Models.Song:new(self.Modules.Songs.testsong)

	local Engine = self.Controllers.Engine

	local newGame = Engine:NewGame({
		scrollSpeedMs = 500;
		song = song;
		keybinds = {
			Enum.KeyCode.X;
			Enum.KeyCode.C;
			Enum.KeyCode.Comma;
			Enum.KeyCode.Period;
		};
	})
	
	local time__ = 0
	
	RunService.Heartbeat:Connect(function(dt)
		time__ += dt*1000
		newGame.services.ObjectPool:Update(time__)
	end)

	newGame.services.ObjectPool:Update(50)
end


return GameController