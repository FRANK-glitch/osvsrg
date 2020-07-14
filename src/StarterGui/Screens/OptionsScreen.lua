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
local UI = require(Frameworks.UI)

local UserInputService = game:GetService("UserInputService")

local self = {}

local handle = {}
local tree = {}

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
	self[bound], self[boundFire] = Roact.createBinding(Settings.Options[bound])
	optionNumber = optionNumber + 1
	return Roact.createElement("Frame", {
		Size = UDim2.new(0.975,0,0.075,0);
		Position = UDim2.new(0, 0, (optionNumber-2) / (maxOptionNumber * 2) + ((optionNumber - 2) / 100), 0);
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
				Text = self[bound],
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
					self[boundFire](optionValue)
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
					self[boundFire](optionValue)
				end
			})
		});
	})
end

local function KeybindOption(name, bound, numOfKeys)
	numOfKeys = numOfKeys or 1
	local boundFire = "Update"..bound
	self[bound], self[boundFire] = Roact.createBinding(Settings.Options[bound])
	optionNumber = optionNumber + 1
	return Roact.createElement("Frame", {
		Size = UDim2.new(0.975,0,0.075,0);
		Position = UDim2.new(0, 0, (optionNumber-2) / (maxOptionNumber * 2) + ((optionNumber - 2) / 100), 0);
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
				Text = self[bound]:map(function(val)
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
					self[boundFire](Settings.Options[bound])
					for i = 1, numOfKeys do
						local u = UserInputService.InputBegan:Wait()
						Settings.Options[bound][i] = u.KeyCode
						self[boundFire](Settings.Options[bound])
					end
				end
			})
		});
	})
end

local function BoolOption(name, bound)
	local boundFire = "Update"..bound
	self[bound], self[boundFire] = Roact.createBinding(Settings.Options[bound])
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
			ImageColor3 = self[bound]:map(function(val)
				return val and Color3.fromRGB(14, 238, 51) or Color3.fromRGB(253, 60, 34)
			end),
		},{
			Data = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.7, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = self[bound]:map(function(val)
					return val and "ON" or "OFF"
				end),
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(179, 179, 179),
				[Roact.Event.MouseButton1Click] = function(rbx)
					local newVal = Settings:ChangeOption(bound, not Settings.Options[bound])
					self[boundFire](newVal)
				end
			})
		});
	})
end

local function ColorOption(name, bound)
	local boundFire = "Update"..bound
	self[bound], self[boundFire] = Roact.createBinding(Settings.Options[bound])
	self.sliderRef = Roact.createRef()
	self.sliderRef1 = Roact.createRef()
	self.mouseDown = false
	self.mouseDown1 = false
	self.hueB, self.hueC = Roact.createBinding(Settings.Options[bound])
	optionNumber = optionNumber + 1

	local o = Settings.Options[bound]
	local v = o.Value
	local s = o.Saturation
	local h = o.Hue
	local vcurScale = 0

	if s == 1 then
		vcurScale = 1-(v/2)
	else
		vcurScale = s/2
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(0.975,0,0.075,0);
		Position = UDim2.new(0, 0, (optionNumber-2) / (maxOptionNumber * 2) + ((optionNumber - 2) / 100), 0);
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
		-- COLOR RAINBOW HAS ISSUES
		ColorRainbow = Roact.createElement("Frame", {
			Size = UDim2.new(0.4,0,0.5,0);
			AnchorPoint = Vector2.new(0,0.5);
			Position = UDim2.new(0.3,0,0.5,0);
			BorderSizePixel = 0;
			[Roact.Ref] = self.sliderRef;
			[Roact.Event.MouseMoved] = function(rbx, x, y)
				local slider = self.sliderRef:getValue()
				local sx = x-slider.AbsolutePosition.X
				if self.mouseDown then
					local cursor = slider.Cursor
					if cursor then
						local hue = sx/slider.AbsoluteSize.X
						local originalColor = Settings.Options[bound]
						local newColor = Color:changeHSV(originalColor, {
							Hue = 1-hue
						})
						Settings:ChangeOption(bound, newColor)
						self.hueC(Settings.Options[bound])
						cursor.Position = UDim2.new(hue,0,0,0)
					end
				end
			end
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = getRainbow()
			});
			Cursor = Roact.createElement("ImageButton", {
				BackgroundColor3 = Color3.new(0,0,0);
				BorderSizePixel = 0;
				Size = UDim2.new(0,5,1,0);
				Position = UDim2.new(1-Settings.Options[bound].Hue,0,0,0);
				AnchorPoint = Vector2.new(0.5,0);
				ImageTransparency = 1;
				BackgroundTransparency = 0;
				[Roact.Event.MouseButton1Down] = function(rbx)
					self.mouseDown = true
				end;
				[Roact.Event.MouseButton1Up] = function(rbx)
					self.mouseDown = false
				end;
			})
		});
		ColorValue = Roact.createElement("Frame", {
			Size = UDim2.new(0.2,0,0.5,0);
			AnchorPoint = Vector2.new(0,0.5);
			Position = UDim2.new(0.72,0,0.5,0);
			BorderSizePixel = 0;
			[Roact.Ref] = self.sliderRef1;
			[Roact.Event.MouseMoved] = function(rbx, x, y)
				local slider = self.sliderRef1:getValue()
				local sx = x-slider.AbsolutePosition.X
				local threshold = 0.5
				if self.mouseDown1 then
					local cursor = slider.Cursor
					if cursor then
						local value = sx/slider.AbsoluteSize.X
						local originalColor = Settings.Options[bound]
						local newColor
						if value > 0.5 then
							newColor = Color:changeHSV(originalColor, {
								Saturation = 1;
								Value = 1-((value-0.5)*2);
							})
						elseif value < 0.5 then
							newColor = Color:changeHSV(originalColor, {
								Saturation = value*2;
								Value = 1;
							})
						end
						Logger:Log(string.format("New note color: H: %0.2f S: %0.2f V: %0.2f ", newColor.Hue, newColor.Saturation, newColor.Value))
						Settings:ChangeOption(bound, newColor)
						cursor.Position = UDim2.new(value,0,0,0)
					end
				end
			end
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = self.hueB:map(function(clr)
					local tab = {}
					for i, v in pairs(clr) do
						tab[i] = v
					end
					local brightSpec = Color:changeHSV(tab, {
						Saturation = 1;
						Value = 1;
					})
					return getHue(Color:convertHSV(brightSpec))
				end)
			});
			Cursor = Roact.createElement("ImageButton", {
				BackgroundColor3 = Color3.new(0,0,0);
				Size = UDim2.new(0,5,1,0);
				BorderSizePixel = 0;
				Position = UDim2.new(vcurScale,0,0,0);
				AnchorPoint = Vector2.new(0.5,0);
				ImageTransparency = 1;
				BackgroundTransparency = 0;
				[Roact.Event.MouseButton1Down] = function(rbx)
					self.mouseDown1 = true
				end;
				[Roact.Event.MouseButton1Up] = function(rbx)
					self.mouseDown1 = false
				end;
			})
		})
	})
end

local totalSections = 5

local function NewSection(name, children)
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
				self:Update()
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
	return {
		NewSection("General", {
			NumberOption("Song Rate", "Rate", 0.05, {min=0.5, max=5});
			NumberOption("Scroll Speed", "ScrollSpeed");
			BoolOption("Show Marvs", "ShowMarvs");
			BoolOption("Show Perfs", "ShowPerfs");
			BoolOption("Show Greats", "ShowGreats");
			BoolOption("Show Goods", "ShowGoods");
			BoolOption("Show Bads", "ShowBads");
			BoolOption("Show Misses", "ShowMisses");
		});
		NewSection("Keybinds", {
			KeybindOption("Gameplay keys", "Keybinds", 4);
			KeybindOption("Quick exit key", "QuickExitKeybind", 1);
			KeybindOption("Hide gameplay elements", "HideGameplayUI", 1);
		});
		NewSection("Customization", {
			ColorOption("Note color", "NoteColor");
			NumberOption("Field Of View", "FOV", 5);
		});
		NewSection("Configuration", {
			NumberOption("Song Select Rate Increment", "SongSelectRateIncrement", 0.05, {min=0.05, max=2});
		});
	}
end

--[[Settings:BindToSetting("NoteColor", function(newColor)
	Logger:Log(string.format("New note color: H: %0.2f S: %0.2f V: %0.2f ", newColor.Hue, newColor.Saturation, newColor.Value))
end)]]--

local function Base()
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
					self:Unmount()
					Screens:FindScreen("MainMenuScreen"):DoOptions()
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

function self:DoOptions()
	tree = Base()
	handle = Roact.mount(tree, PlayerGui, "Options")
end

function self:Update()
	print("self:Update() was called with no arguments.")
	tree = Base()
	Roact.update(handle,tree)
end

function self:Unmount()
	Roact.unmount(handle)
end

return self