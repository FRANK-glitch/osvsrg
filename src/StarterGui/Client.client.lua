--[[

CLIENT.LUA

CLIENT SIDE LOGIC FOR ROBEATS CS

--]]

repeat wait() until game.Players.LocalPlayer.Character ~= nil
game.Players.LocalPlayer.Character:Destroy()
game.Players.LocalPlayer.Character = nil
local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Screens = PlayerGui:WaitForChild("Screens")
local Utils = script.Parent:WaitForChild("Utils")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local store = Rodux.Store.new(function(state, action)
    state = state or {
        curScreen = nil
    }

    if action.type == "switchScreen" then
        state.curScreen = action.screen
    end

    return state
end,{},{Rodux.loggerMiddleware})

store:dispatch({type = "switchScreen", screen = "MainMenuScreen"})

local ScreenCon = RoactRodux.connect(
    function(state, props)
        return {
            curScreen = state.curScreen
        }
    end,
    function(dispatch)
        return {
			switchScreens = function(screen)
				dispatch({
					type = "switchScreen";
					screen = screen;
				})
			end
        }
    end
)

local function Screen(props)
    return Roact.createElement(ScreenCon(require(Screens:FindFirstChild(props.name))))
end

local app = Roact.createElement(RoactRodux.StoreProvider, {
    store = store,
}, {
    Roact.createElement("ScreenGui", {}, {
        MainMenuScreen = Roact.createElement(Screen, {name="MainMenuScreen"});
        OptionsScreen = Roact.createElement(Screen, {name="OptionsScreen"});
        SongSelectScreen = Roact.createElement(Screen, {name="SongSelectScreen"})
    })
})

Roact.mount(app, LocalPlayer.PlayerGui, "GameUI")


-- CMDR STUFF
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))
Cmdr:SetActivationKeys({ Enum.KeyCode.BackSlash })
