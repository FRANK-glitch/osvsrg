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
local Color = require(Utils.Color)
local SongLibrary = require(Utils.Songs)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

SongLibrary:Initialize()

local store = Rodux.Store.new(function(state, action)
    state = state or {}

    if action.type == "modifySetting" then
        state.Settings[action.setting] = action.value
    end

    if action.type == "switchScreen" then
        state.curScreen = action.screen
    end

    if action.type == "switchSong" then
        state.curSelected = action.song
    end

    return state
end,{
    Settings = {
        ScrollSpeed = 20;
        NoteColor = Color:newHSV(0,0,255);
        Rate = 1;
        ShowGameplayUI = true;
        Keybinds = {
            [1] = Enum.KeyCode.Z;
            [2] = Enum.KeyCode.X;
            [3] = Enum.KeyCode.Comma;
            [4] = Enum.KeyCode.Period;
        };
        QuickExitKeybind = {
            [1] = Enum.KeyCode.Backspace;
        };
        HideGameplayUI = {
            [1] = Enum.KeyCode.M;
        };
        ScorePos = UDim2.new(0.92,0,0.035,0);
        AccuracyPos = UDim2.new(0.92,0,0.08,0);
        ComboPos = UDim2.new(0.5,0,0.2,0);
        JudgementPos = UDim2.new(0.5,0,0.25,0);
        RatingPos = UDim2.new(0.065,0,0.05,0);
        BackButtonPos = UDim2.new(0.923,0,0.955,0);
        FOV = 70;
        RateIncrement = 0.05;
        ShowMarvs = true;
        ShowPerfs = true;
        ShowGreats = true;
        ShowGoods = true;
        ShowBads = true;
        ShowMisses = true;
    }
})

--,{Rodux.loggerMiddleware}

local songs = SongLibrary:GetAllSongs()

store:dispatch({type = "switchScreen", screen = "MainMenuScreen"})
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
        print(RoactRodux.shallowEqual(state, otable))
        otable = newState
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
