local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local Utils = script.Parent.Parent.Utils
local Screens = require(Utils.ScreenUtil) 
local SongLibrary = require(Utils.Songs)
local Online = require(Utils.Online)
local Metrics = require(Utils.Metrics)
local Math = require(Utils.Math)
local Settings = require(Utils.Settings)
local Game = require(Utils.Game)
local Search = require(Utils.Search)
local Logger = require(Utils.Logger):register(script)
local Color = require(Utils.Color)
local Keybind = require(Utils.Keybind)
local Sorts = require(Utils.Sorts)

local SongButton = Roact.Component:extend("SongButton")

function SongButton:init()
    self:setState({
        rate = 1;
    })
end

function SongButton:render()
    local song = self.props.song
    local songNum = self.props.songNum
    local difficulty = Math.avg(song:GetDifficulty()*Metrics:CalculateRateMult(self.state.rate))
    return Roact.createElement("ImageButton", {
		Size = UDim2.new(0.975,0,0,60);
		BackgroundColor3 = song:GetButtonColor();
		Position = UDim2.new(0,0,0,(songNum-1)*60);
		Image = "";
		BorderSizePixel = 0;
		[Roact.Event.MouseButton1Click] = function()
			self.props.changeSong()
		end
	}, {
		Difficulty = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0,0.5);
			Size = UDim2.new(0.125,0,0.8,0);
			BackgroundTransparency = 1;
			Position = UDim2.new(0.01,0,0.5,0);
			TextScaled = true;
			Font = Enum.Font.GothamBlack;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextStrokeTransparency = 0.75;
			Text = "[" .. difficulty .. "]",
		}),
		SongName = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.85,0,0.5,0);
			BackgroundTransparency = 1;
			Position = UDim2.new(0.15,0,0.05,0);
			TextScaled = true;
			Font = Enum.Font.GothamBlack;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextStrokeTransparency = 0.75;
			Text = song:GetSongName(),
			TextXAlignment = Enum.TextXAlignment.Left;
		}),
		ArtistAndMapperName = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.85,0,0.4,0);
			BackgroundTransparency = 1;
			Position = UDim2.new(0.15,0,0.5,0);
			TextScaled = true;
			Font = Enum.Font.GothamBlack;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextStrokeTransparency = 0.75;
			Text = string.format("%s - %s", song:GetArtist(), song:GetCreator());
			TextXAlignment = Enum.TextXAlignment.Left;
		}),
	})
end

return SongButton