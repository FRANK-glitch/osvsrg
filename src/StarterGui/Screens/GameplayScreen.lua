local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)
local LocalPlayer = game.Players.LocalPlayer

local Utils = script.Parent.Parent.Utils
local Screens = require(Utils.ScreenUtil) 
local SongLibrary = require(Utils.Songs)
local Online = require(Utils.Online)
local Metrics = require(Utils.Metrics)
local Math = require(Utils.Math)
local Settings = require(Utils.Settings)
local Keybind = require(Utils.Keybind)
local Logger = require(Utils.Logger):register(script)
local DateTime = require(ReplicatedStorage.DateTime)

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Frameworks = PlayerGui.Frameworks
local Graph = require(Frameworks.Graph)

local GameplayScreen = Roact.Component:extend("GameplayScreen")

local self_ = {}

function GameplayScreen:init()

end

function GameplayScreen:render()
    local rate = self.props.settings.Rate
    local song = self.props.curSelected
    local songStats = self.props.songStats
    local settings = self.props.settings


    local marvs = songStats.marvs
    local perfs = songStats.perfs
    local greats = songStats.greats
    local goods = songStats.goods
    local okays = songStats.okays
    local misses = songStats.misses
    local total = songStats.total
    local acc = songStats.accuracy
    local score = songStats.score
    local chain = songStats.combo
    local maxcombo = songStats.maxcombo
    
    --local game_join = self_._local_services._game_join

    local curTime = 0
    local songLen = 1

    --songLen - curTime
    local timeLeftMs = 5000
    local timeLeftAlpha = curTime/songLen
    local unformattedTL = DateTime:GetDateTime(timeLeftMs/1000/rate)
    local formattedTL = unformattedTL:format("#m:#s")

    local rating = Metrics:CalculateSR(rate or 1, song:GetDifficulty(), acc)

    local gradedata = Metrics:GetGradeData(acc)
    local tierdata = Metrics:GetTierData(rating)

    return Roact.createElement("ScreenGui", {
        Enabled = self.props.curScreen == script.Name
    }, {
        Score = Roact.createElement("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(25,25,25);
            TextColor3 = Color3.fromRGB(255,255,255);
			BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Right;
            Text = Math.format(Math.round(score));
            TextScaled = true;
			TextWrapped = true;
			Font = Enum.Font.GothamBlack;
            AnchorPoint = Vector2.new(0.5,0.5);
            Position = settings.ScorePos;
            Size = UDim2.new(0.15,0,0.06,0);
            Visible = settings.ShowGameplayUI;
        });
        Accuracy = Roact.createElement("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(25,25,25);
            TextColor3 = gradedata.Color;
            TextXAlignment = Enum.TextXAlignment.Right;
			BackgroundTransparency = 1;
            Text = Math.round(acc, 2) .. "% (" .. gradedata.Title .. ")";
            TextScaled = true;
			TextWrapped = true;
			Font = Enum.Font.GothamBlack;
            AnchorPoint = Vector2.new(0.5,0.5);
            Position = settings.AccuracyPos;
            Size = UDim2.new(0.15,0,0.03,0);
            Visible = settings.ShowGameplayUI;
        });
		Combo = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1;
            Text = chain .. "x";
			TextColor3 = Color3.fromRGB(255,255,255);
            TextScaled = true;
			TextWrapped = true;
			Font = Enum.Font.GothamBlack;
            AnchorPoint = Vector2.new(0.5,0.5);
            Position = settings.ComboPos;
            Size = UDim2.new(0.125,0,0.05,0);
            Visible = settings.ShowGameplayUI;
        });
		Judgement = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1;
            Text = "";
			TextColor3 = Color3.fromRGB(255,255,255);
            TextScaled = true;
			TextWrapped = true;
			Font = Enum.Font.GothamBlack;
            AnchorPoint = Vector2.new(0.5,0.5);
            Position = settings.JudgementPos;
            Size = UDim2.new(0.15,0,0.05,0);
            Visible = settings.ShowGameplayUI;
        });
        Rating = Roact.createElement("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(25,25,25);
            TextColor3 = tierdata.Color;
			BackgroundTransparency = 1;
            Text = Math.round(rating, 2) .. " SR";
            TextScaled = true;
			TextWrapped = true;
            Font = Enum.Font.GothamBlack;
            AnchorPoint = Vector2.new(0.5,0.5);
            Position = settings.RatingPos;
            Size = UDim2.new(0.125,0,0.05,0);
            Visible = settings.ShowGameplayUI;
        });
		BackButton = Roact.createElement("ImageButton", {
			Size = UDim2.new(0.14, 0, 0.06, 0),
			AnchorPoint = Vector2.new(0.5,0.5);
			Position = settings.BackButtonPos;
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(232, 49, 49),
			[Roact.Event.MouseButton1Click] = function(rbx)
            	game_.force_quit = true
     		end;
		}, {
			Label = Roact.createElement("TextLabel", {
            	TextColor3 = Color3.fromRGB(255,255,255);
				BackgroundTransparency = 1;
            	Text = "BACK";
            	TextScaled = true;
				TextWrapped = true;
				Font = Enum.Font.GothamBlack;
            	AnchorPoint = Vector2.new(0.5,0.5);
           		Position = UDim2.new(0.5,0,0.5,0);
				Size = UDim2.new(0.9,0,0.6,0);
        	});
        });
        TimeLeftPGBar = Roact.createElement("Frame", {
            Size = UDim2.new(timeLeftAlpha,0,0,5);
            AnchorPoint = Vector2.new(0,1);
            Position = UDim2.new(0,0,1,0);
			      BackgroundColor3 = Color3.fromRGB(122, 122, 122);
			      Visible = settings.ShowGameplayUI;
        });
        TimeLeftTextLabel = Roact.createElement("TextLabel", {
            Text = formattedTL;
            TextSize = 20;
            TextColor3 = Color3.new(1,1,1);
            TextStrokeTransparency = 0.75;
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            Size = UDim2.new(0.1,0,0.05,0);
            AnchorPoint = Vector2.new(0,1);
            Position = UDim2.new(0.005,0,0.995,0);
            Font = Enum.Font.GothamBlack;
            BackgroundColor3 = Color3.fromRGB(122, 122, 122);
            Visible = settings.ShowGameplayUI;
        });
    })
end

return GameplayScreen
