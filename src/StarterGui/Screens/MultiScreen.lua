local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)
local FastSpawn = require(game.ReplicatedStorage.FastSpawn)
local DateTime = require(game.ReplicatedStorage.DateTime)
local Boundary = require(game.ReplicatedStorage.Frameworks.Boundary)
local LocalPlayer = game.Players.LocalPlayer

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

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Frameworks = PlayerGui.Frameworks
local Graph = require(Frameworks.Graph)

local songs = SongLibrary:GetAllSongs()

local self = {}

local handle = {}
local tree = {}

local search = ""

local function Base()
	return Roact.createElement("ScreenGui",{},{
		SongSelectFrame=Roact.createElement("Frame", {
			Size = UDim2.new(1,0,1,0);
			AnchorPoint = Vector2.new(0.5,0.5);
			Position = UDim2.new(0.5, 0,0.5, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(32, 32, 32),
		}, {
			Scale = Roact.createElement("UIScale", {
				Scale = 0.8,
			}),
			Background = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(1, 0, 0.2, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Crop,
				BackgroundColor3 = Color3.fromRGB(223, 179, 179),
				BackgroundTransparency = 0,
				ScaleType = Enum.ScaleType.Crop,
				ImageTransparency = 1,
				--Image = "http://www.roblox.com/asset/?id=2404285030"
			}),
			SearchBox = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(1,0);
				Position = UDim2.new(0.99, 0,0.87, 0),
				Size = UDim2.new(0.4,0,0.06,0),
				BackgroundColor3 = Color3.fromRGB(25, 25, 25),
				BorderSizePixel = 0,
			},{
				SearchBar = Roact.createElement("TextBox", {
					AnchorPoint = Vector2.new(0.5,0.5);
					Text = "";
					PlaceholderText = "Search here";
					PlaceholderColor3 = Color3.fromRGB(178, 178, 178);
					TextColor3 = Color3.fromRGB(255, 255, 255);
					TextScaled = true;
					Font = Enum.Font.GothamBlack;
					BackgroundTransparency = 1;
					Position = UDim2.new(0.5,0,0.5,0);
					Size = UDim2.new(0.98,0,0.55,0);
					[Roact.Event.Changed] = function(rbx)
						local text = rbx.Text
						if text == "" then
							text = nil
						end
						search = text
						tree = Base()
						Roact.update(handle,tree)
					end;
				});
			}),
			BackButton = Roact.createElement("ImageButton", {
				BackgroundColor3 = Color3.fromRGB(232, 49, 49),
				Size = UDim2.new(0.3, 0, 0.05, 0),
				Position =  UDim2.new(0.01,0,0.99,0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				Image = "rbxassetid://2790382281",
				SliceCenter = Rect.new(4, 4, 252, 252),
				SliceScale = 1,
				ImageColor3 = Color3.fromRGB(232, 49, 49),
				AnchorPoint =  Vector2.new(0,1),
				[Roact.Event.MouseButton1Click] = function()
					self:Unmount()
					Screens:FindScreen("MainMenuScreen"):DoOptions()
				end;
			}, {
				BackButton = Roact.createElement("TextLabel", {
					TextStrokeTransparency = 0.75;
					AnchorPoint =  Vector2.new(0.5,0.5),
					Text = "BACK",
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0.9, 0, 0.6, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBlack,
					TextScaled = true,
					TextWrapped = true,
					TextColor3 = Color3.fromRGB(255, 255, 255)
				});
			});
			PlayButton = Roact.createElement("ImageButton", {
				BackgroundColor3 = Color3.fromRGB(43, 255, 110),
				Size = UDim2.new(0.4, 0, 0.05, 0),
				Position =  UDim2.new(0.59,0,0.99,0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				Image = "rbxassetid://2790382281",
				SliceCenter = Rect.new(4, 4, 252, 252),
				SliceScale = 1,
				ImageColor3 = Color3.fromRGB(43, 255, 110),
				AnchorPoint =  Vector2.new(0,1),
				[Roact.Event.MouseButton1Click] = function()
					Boundary.Client:Execute("CreateNewRoom")
				end;
			}, {
				PlayButtonText = Roact.createElement("TextLabel", {
					TextStrokeTransparency = 0.75;
					AnchorPoint =  Vector2.new(0.5,0.5),
					Text = "CREATE ROOM",
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0.9, 0, 0.6, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBlack,
					TextScaled = true,
					TextWrapped = true,
					TextColor3 = Color3.fromRGB(255, 255, 255)
				});
			});
		})
	})
end

function self:ShowList()
	Logger:Log("Entering multi screen...")
	tree = Base()
	handle = Roact.mount(tree, PlayerGui, "SongSelect")
	Logger:Log("Multi screen mounted!")
end

function self:Redraw()
	tree = Base()
	Roact.update(handle,tree)
end

function self:Unmount()
	Roact.unmount(handle)
	Logger:Log("Multi screen unmounted!")
end

return self