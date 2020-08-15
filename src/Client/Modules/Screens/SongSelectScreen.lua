-- Song Select Screen
-- kisperal 
-- August 15, 2020

local Roact: Roact
local Component
local Metrics
local Date

local SongSelectScreen = {}

function SongSelectScreen:init()
    Roact = self.Shared.Roact
    Component = self.Modules.Utils.Roact.Component
    Metrics = self.Modules.Utils.Metrics
    Date = self.Shared.Date
end

function SongSelectScreen:render()
    print("CRINGE.")

    local rate = self.props.settings.Rate

	local rate_s = "Song Rate: " .. rate .. "x"
	
	local rateMult = Metrics:CalculateRateMult(rate or 1)

	local length = 25000
	local dtTime = Date.new((length/1000)/rate)
	local songLength = string.format("Song Length: %d:%d", dtTime.Minute, dtTime.Second)

	local sbuttons, found = {}, 0

    return Roact.createElement("ScreenGui",{
		Enabled = self.props.curScreen == script.Name
	}, {
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
				BackgroundColor3 = Color3.fromRGB(223, 179, 179),
				BackgroundTransparency = 0,
				ScaleType = Enum.ScaleType.Crop,
				ImageTransparency = 1,
				--Image = "http://www.roblox.com/asset/?id=2404285030"
			}, {
				ArtistName = Roact.createElement("ImageLabel", {
					Size = UDim2.new(0.5, 0, 0.3, 0),
					Position = UDim2.new(0.02, 0, 0.35, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					Image = "rbxassetid://2790382281",
					SliceCenter = Rect.new(4, 4, 252, 252),
					SliceScale = 1,
					ImageColor3 = Color3.fromRGB(27, 27, 27)
				}, {
					Data = Roact.createElement("TextLabel", {
						AnchorPoint = Vector2.new(0.5,0.5);
						Text = "";
						TextColor3 = Color3.new(1,1,1);
						TextScaled = true;
						BackgroundTransparency = 1;
						Position = UDim2.new(0.5,0,0.55,0);
						Size = UDim2.new(0.96,0,0.6,0);
						Font = Enum.Font.GothamBlack;
					});
				}),
				SongName = Roact.createElement("ImageLabel", {
					Size = UDim2.new(0.5, 0, 0.3, 0),
					Position = UDim2.new(0.02, 0, 0.1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					Image = "rbxassetid://2790382281",
					SliceCenter = Rect.new(4, 4, 252, 252),
					SliceScale = 1,
					ImageColor3 = Color3.fromRGB(35, 35, 35)
				}, {
					Data = Roact.createElement("TextLabel", {
						AnchorPoint = Vector2.new(0.5,0.5);
						Text = "";
						TextColor3 = Color3.new(1,1,1);
						TextScaled = true;
						BackgroundTransparency = 1;
						Position = UDim2.new(0.5,0,0.5,0);
						Size = UDim2.new(0.96,0,0.7,0);
						Font = Enum.Font.GothamBlack;
					});
				}),
				DifficultyName = Roact.createElement("ImageLabel", {
					Size = UDim2.new(0.5, 0, 0.25, 0),
					Position = UDim2.new(0.02, 0, 0.7, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					Image = "rbxassetid://2790382281",
					SliceCenter = Rect.new(4, 4, 252, 252),
					SliceScale = 1,
					ImageColor3 = Color3.fromRGB(27, 27, 27)
				}, {
					Data = Roact.createElement("TextLabel", {
						AnchorPoint = Vector2.new(0.5,0.5);
						Text = "";
						TextColor3 = Color3.new(1,1,1);
						TextScaled = true;
						BackgroundTransparency = 1;
						Position = UDim2.new(0.5,0,0.5,0);
						Size = UDim2.new(0.96,0,0.7,0);
						Font = Enum.Font.GothamBlack;
					});
				}),
				SongLen = Roact.createElement("TextLabel", {
					Position = UDim2.new(0.99,0,0.6,0);
					Size = UDim2.new(0.3, 0, 0.245555, 0);
					TextXAlignment = Enum.TextXAlignment.Right;
					TextScaled = true;
					AnchorPoint = Vector2.new(1,1);
					BackgroundTransparency = 1;
					TextStrokeTransparency = 0.75;
					Font = Enum.Font.GothamBlack;
					TextColor3 = Color3.fromRGB(255, 255, 255);
					Text = songLength;
				}),
				SongRate = Roact.createElement("TextLabel", {
					Position = UDim2.new(0.99,0,0.845555,0);
					Size = UDim2.new(0.3, 0, 0.245555, 0);
					TextXAlignment = Enum.TextXAlignment.Right;
					TextSize = 28;
					AnchorPoint = Vector2.new(1,1);
					BackgroundTransparency = 1;
					TextStrokeTransparency = 0.75;
					Font = Enum.Font.GothamBlack;
					TextColor3 = Color3.fromRGB(255, 255, 255);
					Text = 1;
				})
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
					end;
				});
			}),
			--[[Leaderboards = Roact.createElement("Frame", {
				Position = UDim2.new(0.01, 0,0.22, 0),
				Size = UDim2.new(0.3,0,0.71,0),
				BackgroundColor3 = Color3.fromRGB(25, 25, 25),
				BorderSizePixel = 0,
			}, {
				List = Roact.createElement("ScrollingFrame", {
					AnchorPoint = Vector2.new(0.5,0.5);
					Position = UDim2.new(0.5,0,0.5,0);
					Size = UDim2.new(0.96,0,0.97,0);
					BackgroundTransparency = 1;
					BorderSizePixel = 0,
					CanvasSize = UDim2.new(0,0,0,getNumSlots()*72);
					VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left;
					ScrollBarThickness = 6,
					TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
					BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
				}, {
					Layout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
				});
			}),]]--
			--[[NpsGraph = Roact.createElement(NpsGraph, {
				Size = UDim2.new(0.27,0,0.35,0),
				AnchorPoint = Vector2.new(0.5,1),
				Position = UDim2.new(0.45,0,0.99,0),
				BorderSizePixel = 0,
				ZIndex = 2,
				settings = self.props.settings,
				curSelected = self.props.curSelected,
			});]]--
			Songs = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(1,0);
				Position = UDim2.new(0.99, 0,0.22, 0),
				Size = UDim2.new(0.4,0,0.63,0),
				BackgroundColor3 = Color3.fromRGB(25, 25, 25),
				BorderSizePixel = 0,
			}, {
				List = Roact.createElement("ScrollingFrame", {
					AnchorPoint = Vector2.new(0.5,0.5);
					Position = UDim2.new(0.5,0,0.5,0);
					Size = UDim2.new(0.97,0,0.97,0);
					BackgroundTransparency = 1;
					CanvasSize = UDim2.new(0,0,0,60);
					VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right;
					ScrollBarThickness = 6,
					BorderSizePixel = 0,
					TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
					BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
				}, {
					Layout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
					}),
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
					self.props.switchScreens("MainMenuScreen")
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
                    
				end;
			}, {
				PlayButtonText = Roact.createElement("TextLabel", {
					TextStrokeTransparency = 0.75;
					AnchorPoint =  Vector2.new(0.5,0.5),
					Text = "PLAY",
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

return SongSelectScreen