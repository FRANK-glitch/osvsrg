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
local Color = require(Utils.Color)

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Frameworks = PlayerGui.Frameworks
local Graph = require(Frameworks.Graph)

local UserInputService = game:GetService("UserInputService")

local OptionsScreen = Roact.Component:extend("OptionsScreen")

local handle = {}
local tree = {}

local self_ = {}

local curSelected = ""

local optionNumber = 0
local tabNumber = 0
local maxOptionNumber = 7

local function formatColor(color3)
	return string.format("R: %3d, G: %3d, B: %3d", color3.R or 0, color3.G or 0, color3.B or 0)
end

local function formatSingleKey(key)
	if key == -1 then return "..." end
	local str = key.Name
	local replacements = {
		["Comma"] = ",";
		["Slash"] = "/";
		["Period"] = ".";
		["Hash"] = "#";
		["Asterisk"] = "*";
		["Caret"] = "^";
		["Ampersand"] = "&";
		["Quote"] = "\"";
		["Return"] = "Ent";
		["Percent"] = "%";
		["Plus"] = "+";
		["Minus"] = "-";
		["Zero"] = "0";
		["One"] = "1";
		["Two"] = "2";
		["Three"] = "3";
		["Four"] = "4";
		["Five"] = "5";
		["Six"] = "6";
		["Seven"] = "7";
		["Eight"] = "8";
		["Nine"] = "9";
		["Equal"] = "=";
		["LessThan"] = "<";
		["GreaterThan"] = ">";
		["BackSlash"] = "\\";
		["Question"] = "?";
		["Equals"] = "=";
	}
	for i, v in pairs(replacements) do
		if str == i then
			str = v
			break
		end
	end
	return str
end

local function formatKeys(keys)
	local ret = ""
	for i = 1, #keys do
		local v = keys[i]
		local str = formatSingleKey(v)
		local ap_str = i == #keys and str or str .. " "
		ret = ret .. ap_str
	end
	return ret
end

local function enumToNumber(enum)
	return enum.Value - 48
end

local function getRainbow()
	local keypoints = {}
	local numOfPrimary = 12
	for i = 1, numOfPrimary+1 do
		local alpha = (i-1)/numOfPrimary
		keypoints[#keypoints+1] = ColorSequenceKeypoint.new(alpha, Color3.fromHSV(1-alpha, 1, 1 ))
	end
	local sequence = ColorSequence.new(keypoints)
	return sequence
end

local function getHue(clr)
	local white = ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255))
	local black = ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))
	local color = ColorSequenceKeypoint.new(0.5,clr)
	return ColorSequence.new({white,color,black})
end

local function NumberOption(name, bound, increment, clamp)
	local min = nil
    local max = nil
	if clamp ~= nil then
		min = clamp.floor
		max = clamp.ceiling
	end

	increment = increment or 1
	local boundFire = "Update"..bound
	self_[bound], self_[boundFire] = Roact.createBinding(Settings.Options[bound])
	optionNumber = optionNumber + 1
	return Roact.createElement("Frame", {
		Size = UDim2.new(0.975,0,0.075,0);
		Position = UDim2.new(0, 0, (optionNumber-1) / (maxOptionNumber * 2) + ((optionNumber - 1) / 100), 0);
		BackgroundColor3 = Color3.fromRGB(27, 27, 27);
		BorderSizePixel = 0;
	}, {
		Name = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5);
			BackgroundTransparency = 1;
			Font = Enum.Font.GothamBlack;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			Text = name;
			TextScaled = true,
			TextWrapped = true,
			Position = UDim2.new(0.025,0,0.5,0);
			Size = UDim2.new(0.2,0,0.25,0);
		});
		OptionValue = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0.225,0,0.5,0),
			Position = UDim2.new(0.25,0,0.5,0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(35, 35, 35)
		},{
			Data = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.7, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = self_[bound],
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(179, 179, 179)
			})
		});
		Plus = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0.2,0,0.5,0),
			Position = UDim2.new(0.8,-60,0.5,0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(32, 221, 32)
		},{
			Data = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.7, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "+",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				[Roact.Event.MouseButton1Click] = function(rbx)
					local optionValue = Settings:Increment(bound, increment, clamp or {})
					self_[boundFire](optionValue)
				end
			})
		});
		Minus = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0.2,0,0.5,0),
			Position = UDim2.new(1,-30,0.5,0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(209, 47, 47)
		},{
			Data = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.7, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "-",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				[Roact.Event.MouseButton1Click] = function(rbx)
					local optionValue = Settings:Increment(bound, -increment, clamp or {})
					self_[boundFire](optionValue)
				end
			})
		});
	})
end

local function KeybindOption(name, bound, numOfKeys)
	numOfKeys = numOfKeys or 1
	local boundFire = "Update"..bound
	self_[bound], self_[boundFire] = Roact.createBinding(Settings.Options[bound])
	optionNumber = optionNumber + 1
	return Roact.createElement("Frame", {
		Size = UDim2.new(0.975,0,0.075,0);
		Position = UDim2.new(0, 0, (optionNumber-1) / (maxOptionNumber * 2) + ((optionNumber - 1) / 100), 0);
		BackgroundColor3 = Color3.fromRGB(27, 27, 27);
		BorderSizePixel = 0;
	}, {
		Name = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1;
			Font = Enum.Font.GothamBlack;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			Text = name;
			TextScaled = true,
			TextWrapped = true,
			Position = UDim2.new(0.025,0,0.5,0);
			Size = UDim2.new(0.2,0,0.25,0);
		});
		OptionValue = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0.4,0,0.5,0),
			Position = UDim2.new(0.95,0,0.5,0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(35, 35, 35)
		},{
			Data = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.7, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = self_[bound]:map(function(val)
					return formatKeys(val)
				end),
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(179, 179, 179),
				[Roact.Event.MouseButton1Click] = function(rbx)
					Settings:ChangeOption(bound, {
						[1] = -1;
						[2] = -1;
						[3] = -1;
						[4] = -1;
					})
					self_[boundFire](Settings.Options[bound])
					for i = 1, numOfKeys do
						local u = UserInputService.InputBegan:Wait()
						Settings.Options[bound][i] = u.KeyCode
						self_[boundFire](Settings.Options[bound])
					end
				end
			})
		});
	})
end

local function BoolOption(name, bound)
	local boundFire = "Update"..bound
	self_[bound], self_[boundFire] = Roact.createBinding(Settings.Options[bound])
	optionNumber = optionNumber + 1
	return Roact.createElement("Frame", {
		Size = UDim2.new(0.975,0,0.075,0);
		Position = UDim2.new(0, 0, (optionNumber-1) / (maxOptionNumber * 2) + ((optionNumber - 1) / 100), 0);
		BackgroundColor3 = Color3.fromRGB(27, 27, 27);
		BorderSizePixel = 0;
	}, {
		Name = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1;
			Font = Enum.Font.GothamBlack;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			Text = name;
			TextScaled = true,
			TextWrapped = true,
			Position = UDim2.new(0.025,0,0.5,0);
			Size = UDim2.new(0.2,0,0.25,0);
		});
		OptionValue = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0.4,0,0.5,0),
			Position = UDim2.new(0.95,0,0.5,0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = self_[bound]:map(function(val)
				return val and Color3.fromRGB(14, 238, 51) or Color3.fromRGB(253, 60, 34)
			end),
		},{
			Data = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.7, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = self_[bound]:map(function(val)
					return val and "ON" or "OFF"
				end),
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(179, 179, 179),
				[Roact.Event.MouseButton1Click] = function(rbx)
					local newVal = Settings:ChangeOption(bound, not Settings.Options[bound])
					self_[boundFire](newVal)
				end
			})
		});
	})
end



local totalSections = 5

local function NewSection(name, children, default)
	if default and curSelected == "" then
		curSelected = name
	end
	children = children or {}
	optionNumber = 0
	tabNumber = tabNumber + 1
	local isSelected = curSelected == name
	return {
		Tab = Roact.createElement("TextButton", {
			Font = Enum.Font.GothamBlack;
			TextSize = 0;
			BackgroundTransparency = isSelected and 0.25 or 1;
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Size = UDim2.new(1,0,1/totalSections,0);
			Position = UDim2.new(0,0,(tabNumber-1)/totalSections,0);
			[Roact.Event.MouseButton1Click] = function(rbx)
				optionNumber = 0
				curSelected = name
				self_:Update()
			end
		}, {
			Text = Roact.createElement("TextLabel", {
				AnchorPoint =  Vector2.new(0.5,0.5),
				Text = name,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0.7, 0, 0.275, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = isSelected and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
			});
		});
		OptionsList = Roact.createFragment(children);
		Name = name;
	}
end

local function Sections()
	tabNumber = 0
	return {}
end

--[[Settings:BindToSetting("NoteColor", function(newColor)
	Logger:Log(string.format("New note color: H: %0.2f S: %0.2f V: %0.2f ", newColor.Hue, newColor.Saturation, newColor.Value))
end)]]--

function OptionsScreen:init()
	self:setState({
		name = "OptionsScreen"
	})
end

function OptionsScreen:render()
	optionNumber = 0
	local sections = Sections()
	local tabs = {}
	local options = {}

	for i , v in pairs(sections) do
		tabs[i] = v.Tab
		if v.Name == curSelected then
			options = v.OptionsList
		end
	end

	tabs = Roact.createFragment(tabs)

	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		Enabled = self.props.curScreen == self.state.name
	}, {
		OptionsFrame = Roact.createElement("ImageLabel", {
			AnchorPoint =  Vector2.new(0.5,0.5);
			Position =  UDim2.new(0.5,0,0.5,0);
			BackgroundColor3 = Color3.fromRGB(12,12,12);
			BackgroundTransparency = 0.2;
			Size = UDim2.new(1,0,1,0);
			BorderSizePixel = 0;
			BackgroundTransparency = 1;
			ScaleType = Enum.ScaleType.Slice;
			Image = "rbxassetid://2790382281";
			SliceCenter = Rect.new(4, 4, 252, 252);
			SliceScale = 1;
			ImageColor3 = Color3.fromRGB(27, 27, 27);
		}, {
			Scale = Roact.createElement("UIScale", {
				Scale = 0.8,
			}),
			Tabs = Roact.createElement("ImageLabel", {
				Size = UDim2.new(0.2,0,0.89,0);
				Position = UDim2.new(0.005,0,0.01,0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				ScaleType = Enum.ScaleType.Slice;
				Image = "rbxassetid://2790382281";
				SliceCenter = Rect.new(4, 4, 252, 252);
				SliceScale = 1;
				ImageColor3 = Color3.fromRGB(17, 17, 17);
			}, tabs),
			OptionsContainer = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0,0.5);
				Size = UDim2.new(0.785,0,0.98,0);
				Position = UDim2.new(0.21,0,0.5,0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				ScaleType = Enum.ScaleType.Slice;
				Image = "rbxassetid://2790382281";
				SliceCenter = Rect.new(4, 4, 252, 252);
				SliceScale = 1;
				ImageColor3 = Color3.fromRGB(17, 17, 17);
			}, {
				List = Roact.createElement("ScrollingFrame", {
				AnchorPoint = Vector2.new(0.5,0.5);
				Size = UDim2.new(0.975,0,0.965,0);
				Position = UDim2.new(0.5,0,0.5,0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
				BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
				ScrollBarThickness = 10
				}, options),
			}),
			BackButton = Roact.createElement("ImageButton", {
				BackgroundColor3 = Color3.fromRGB(232, 49, 49),
				Size = UDim2.new(0.2, 0, 0.08, 0),
				Position =  UDim2.new(0.005,0,0.99,0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				Image = "rbxassetid://2790382281",
				SliceCenter = Rect.new(4, 4, 252, 252),
				SliceScale = 1,
				ImageColor3 = Color3.fromRGB(232, 49, 49),
				AnchorPoint =  Vector2.new(0,1),
				[Roact.Event.MouseButton1Click] = function()
					self.props.switchScreens("MainMenuScreen")
				end;
			}, {
				BackButton = Roact.createElement("TextLabel", {
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
		});
	});
end

return OptionsScreen