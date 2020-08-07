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
local Constants = script.Parent:WaitForChild("Constants")
local InitialState = require(Constants.InitialState)

local Color = require(Utils.Color)
local SongLibrary = require(Utils.Songs)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)
local Llama = require(ReplicatedStorage:WaitForChild("Llama"))

SongLibrary:Initialize()

local reducer = Rodux.createReducer(InitialState, {
    modifySetting = function(state, action)
        return Llama.Dictionary.join(state, {
            Settings = Llama.Dictionary.join(state.Settings, {
                [action.setting] = action.value
            })
        })
    end;
    switchScreen = function(state, action)
        local newState = {}
        for i, v in pairs(state) do
            newState[i] = v
        end
        newState.curScreen = action.screen
        return newState
    end;
    switchSong = function(state, action)
        local newState = {}
        for i, v in pairs(state) do
            newState[i] = v
        end
        newState.curSelected = action.song
        return newState
    end;
});

local store = Rodux.Store.new(reducer)

--,{Rodux.loggerMiddleware}

local songs = SongLibrary:GetAllSongs()
store:dispatch({type = "switchSong", song = songs[1]})

local ScreenCon = nil

local otable = {}

ScreenCon = RoactRodux.connect(
    function(state, props)
        local newState = {
            curScreen = state.curScreen;
            curSelected = state.curSelected;
            settings = state.Settings;
        }
        return newState
    end,
    function(dispatch)
        return {
			switchScreens = function(screen)
				dispatch({
					type = "switchScreen";
					screen = screen;
				})
            end;
            changeSong = function(song)
                dispatch({type = "switchSong", song = song})
            end;
            changeSetting = function(setting, value)
                dispatch({type = "modifySetting", setting = setting, value = value})
            end;
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
        SongSelectScreen = Roact.createElement(Screen, {name="SongSelectScreen"});
    })
})

Roact.mount(app, LocalPlayer.PlayerGui, "GameUI")


-- CMDR STUFF
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))
Cmdr:SetActivationKeys({ Enum.KeyCode.BackSlash })
