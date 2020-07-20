local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local LocalPlayer = game.Players.LocalPlayer

local Utils = script.Parent.Parent.Utils
local Screens = require(Utils.ScreenUtil) 
local Logger = require(Utils.Logger):register(script)

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Frameworks = PlayerGui.Frameworks

local UpdateNotes = require(workspace:WaitForChild("UpdateNotes"))

local self = {}
	
local handle = {}

local options = {}
local numNames = 6

local function GetUpdateNotes()
	local notes = {}
	local numVersions = #UpdateNotes.Versions
	for i, updateNote in pairs(UpdateNotes.Versions) do
		local changet = ""
		for i, change in pairs(updateNote.Changes) do
			changet = changet .. "- " .. change.ChangeText .. "\n"
		end
		notes[i] = Roact.createElement("Frame", {
			BackgroundTransparency=0.4;
			BackgroundColor3 = Color3.new(0.3,0.3,0.3);
			Position = UDim2.new(0, 0, (i-1)/numVersions, 0);
			Size = UDim2.new(1, 0, 0, 200);
		}, {
			Version = Roact.createElement("TextLabel", {
				Font = Enum.Font.GothamBlack;
				Text = "VERSION " .. updateNote.Version;
				BackgroundTransparency = 1;
				TextColor3 = Color3.new(1, 1, 1);
				TextSize = 21;
				Position = UDim2.new(0.05, 0, 0.05, 0);
				Size = UDim2.new(0.9, 0, 0.15, 0);
				TextXAlignment = Enum.TextXAlignment.Left;
				ZIndex = 5;
			});
			Text = Roact.createElement("TextLabel", {
				Font = Enum.Font.GothamBlack;
				TextWrapped = true;
				TextScaled = false;
				TextSize = 18;
				BackgroundTransparency = 1;
				Position = UDim2.new(0.05, 0, 0.25, 0);
				Size = UDim2.new(0.9, 0, 0.74, 0);
				Text = changet;
				TextColor3 = Color3.new(0.8, 0.8, 0.8);
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Top;
				ZIndex = 5;
			});
		})
	end
	return notes
end

function self:DoOptions(props)
	Logger:Log("Main menu mounting...")
	Logger:Log("Max options: " .. numNames)
	local frame = Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global
	}, {
		Menu = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ZIndex = 1,
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(37, 37, 37)	
		}, 
		{
			Scale = Roact.createElement("UIScale", {
				Scale = 0.8,
			}),
			Background = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(1, 0, 0.34, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				ZIndex = 2,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(223, 179, 179),
				BackgroundTransparency = 0,
				ScaleType = Enum.ScaleType.Crop,
				ImageTransparency = 1,
			}, {
				User = Roact.createElement("ImageLabel", {
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0.15, 0, 0.8, 0),
					Position = UDim2.new(0.025, 0, 0.5, 0),
					ZIndex = 7,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					Image = "rbxassetid://2790382281",
					SliceCenter = Rect.new(4, 4, 252, 252),
					SliceScale = 1,
					ImageColor3 = Color3.fromRGB(35, 35, 35)
				}, {
					Scale = Roact.createElement("UIAspectRatioConstraint", {
						DominantAxis = Enum.DominantAxis.Width,
					}),
					Username = Roact.createElement("ImageLabel", {
						Size = UDim2.new(1.25, 0, 0.25, 0),
						Position = UDim2.new(0.9, 0, 0, 0),
						ZIndex = 5,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						ScaleType = Enum.ScaleType.Slice,
						Image = "rbxassetid://2790382281",
						SliceCenter = Rect.new(4, 4, 252, 252),
						SliceScale = 1,
						ImageColor3 = Color3.fromRGB(35, 35, 35)
					}, {
						Data = Roact.createElement("TextLabel", {
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0.85, 0, 0.7, 0),
							Position = UDim2.new(0.125, 0, 0.5, 0),
							ZIndex = 6,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Text = LocalPlayer.Name,
							Font = Enum.Font.GothamBlack,
							TextScaled = true,
							TextWrapped = true,
							TextColor3 = Color3.fromRGB(255, 255, 255)
						})
					}),
					Rank = Roact.createElement("ImageLabel", {
						Size = UDim2.new(1.1, 0, 0.25, 0),
						Position = UDim2.new(0.95, 0, 0.2, 0),
						ZIndex = 3,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						ScaleType = Enum.ScaleType.Slice,
						Image = "rbxassetid://2790382281",
						SliceCenter = Rect.new(4, 4, 252, 252),
						SliceScale = 1,
						ImageColor3 = Color3.fromRGB(27, 27, 27)
					},{
						Data = Roact.createElement("TextLabel", {
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0.825, 0, 0.7, 0),
							Position = UDim2.new(0.15, 0, 0.6, 0),
							ZIndex = 4,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Text = "#1",
							Font = Enum.Font.GothamBlack,
							TextScaled = true,
							TextWrapped = true,
							TextColor3 = Color3.fromRGB(255, 255, 255)
						})
					}),
					Image = Roact.createElement("ImageLabel", {
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					ZIndex = 8,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Fit,
					Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png",
				})
			}),
			Song = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0.25, 0, 0.2, 0),
				Position = UDim2.new(0.98, 0, 0.1, 0),
				ZIndex = 5,
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
					ZIndex = 6,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Text = "FREEDOM DiVE",
					Font = Enum.Font.GothamBlack,
					TextScaled = true,
					TextWrapped = true,
					TextColor3 = Color3.fromRGB(255, 255, 255)
				})
			}),
			Artist = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0.2, 0, 0.2, 0),
				Position = UDim2.new(0.98, 0, 0.25, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				Image = "rbxassetid://2790382281",
				SliceCenter = Rect.new(4, 4, 252, 252),
				SliceScale = 1,
				ImageColor3 = Color3.fromRGB(27, 27, 27)
			},{
				Data = Roact.createElement("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0.85, 0, 0.7, 0),
					Position = UDim2.new(0.5, 0, 0.6, 0),
					ZIndex = 4,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Text = "xi",
					Font = Enum.Font.GothamBlack,
					TextScaled = true,
					TextWrapped = true,
					TextColor3 = Color3.fromRGB(255, 255, 255)
				})
			}),
			MusicPlayer = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0.25, 0, 0.3, 0),
				Position = UDim2.new(0.98, 0, 0.55, 0),
				ZIndex = 5,
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
					ZIndex = 6,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Text = "RoBeats CS",
					Font = Enum.Font.GothamBlack,
					TextScaled = true,
					TextWrapped = true,
					TextColor3 = Color3.fromRGB(255, 255, 255)
				})
			})
		}),
		PlayButton = Roact.createElement("ImageButton", {
			Size = UDim2.new(0.25, 0, 0.08, 0),
			Position = UDim2.new(0.025, 0, 0.38, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(27, 27, 27),
			[Roact.Event.MouseButton1Click] = function()
				self:Unmount()
				Screens:FindScreen("SongSelectScreen"):DoSongSelect()
			end
		}, {
			Label = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.6, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "PLAY",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			})
		}),
		RankingButton = Roact.createElement("ImageButton", {
			Size = UDim2.new(0.25, 0, 0.08, 0),
			Position = UDim2.new(0.025, 0, 0.48, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(27, 27, 27)
		}, {
			Label = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.6, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "RANKING",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			})
		}),
		OptionsButton = Roact.createElement("ImageButton", {
			Size = UDim2.new(0.25, 0, 0.08, 0),
			Position = UDim2.new(0.025, 0, 0.58, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(27, 27, 27),
			[Roact.Event.MouseButton1Click] = function()
				self:Unmount()
				Screens:FindScreen("OptionsScreen"):DoOptions()
			end
		}, {
			Label = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.6, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "OPTIONS",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			})
		}),
		SpectateButton = Roact.createElement("ImageButton", {
			Size = UDim2.new(0.25, 0, 0.08, 0),
			Position = UDim2.new(0.025, 0, 0.68, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(27, 27, 27)
		}, {
			Label = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.6, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "SPECTATE",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			})
		}),
		LeaderboardButton = Roact.createElement("ImageButton", {
			Size = UDim2.new(0.25, 0, 0.08, 0),
			Position = UDim2.new(0.025, 0, 0.78, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(27, 27, 27)
		}, {
			Label = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.6, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "LEADERBOARD",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			})
		}),
		MultiButton = Roact.createElement("ImageButton", {
			Size = UDim2.new(0.25, 0, 0.08, 0),
			Position = UDim2.new(0.025, 0, 0.88, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(27, 27, 27),
			[Roact.Event.MouseButton1Click] = function()
				self:Unmount()
				Screens:FindScreen("MultiScreen"):ShowList()
			end
		}, {
			Label = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.85, 0, 0.6, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "MULTIPLAYER",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			})
		}),
		TopScores = Roact.createElement("ImageLabel", {
			Size = UDim2.new(0.325, 0, 0.58, 0),
			Position = UDim2.new(0.3, 0, 0.38, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(27, 27, 27)
		}, {
			Label = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.9, 0, 0.09, 0),
				Position = UDim2.new(0.5, 0, 0.075, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "TOP SCORES",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			})
		}),
		Updates = Roact.createElement("ImageLabel", {
			Size = UDim2.new(0.325, 0, 0.58, 0),
			Position = UDim2.new(0.65, 0, 0.38, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			Image = "rbxassetid://2790382281",
			SliceCenter = Rect.new(4, 4, 252, 252),
			SliceScale = 1,
			ImageColor3 = Color3.fromRGB(27, 27, 27)
		}, {
			Label = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.9, 0, 0.09, 0),
				Position = UDim2.new(0.5, 0, 0.075, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "UPDATES",
				Font = Enum.Font.GothamBlack,
				TextScaled = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}),
			SFrame = Roact.createElement("ScrollingFrame", {
				CanvasSize = UDim2.new(0,0,0,200*#UpdateNotes.Versions),
				BackgroundTransparency = 1;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(0.9, 0, 0.78, 0);
				AnchorPoint = Vector2.new(0.5, 0.5);
				ZIndex = 4;
			}, GetUpdateNotes())
		}),
		})
	})
	handle = Roact.mount(frame, PlayerGui, "MainMenu")
	Logger:Log("Main menu mounted!")
end
function self:Unmount()
	Roact.unmount(handle)
	Logger:Log("Main menu unmounted!")
end

return self