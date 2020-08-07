local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)
local FastSpawn = require(ReplicatedStorage.FastSpawn)
local DateTime = require(ReplicatedStorage.DateTime)
local Http = require(ReplicatedStorage.Helpers.Http)
local LocalPlayer = game.Players.LocalPlayer

local Utils = script.Parent.Parent.Utils
local Screens = require(Utils.ScreenUtil) 
local SongLibrary = require(Utils.Songs)
local Online = require(Utils.Online)
local Metrics = require(Utils.Metrics)
local Math = require(Utils.Math)
local Game = require(Utils.Game)
local Search = require(Utils.Search)
local Logger = require(Utils.Logger):register(script)
local Color = require(Utils.Color)
local Keybind = require(Utils.Keybind)
local KeybindPool = require(Utils.KeybindPool)
local Sorts = require(Utils.Sorts)

local Components = script.Parent.Parent.Components
local SongButton = require(Components.SongButton)
local NpsGraph = require(Components.NpsGraph)

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Frameworks = PlayerGui.Frameworks
local Graph = require(Frameworks.Graph)

local songs = SongLibrary:GetAllSongs()

local SongSelectScreen = Roact.Component:extend("SongSelectScreen")

local self_ = {}
self_.Keybinds = KeybindPool:new()

local maxSlots = 50

local rateMult = 1

local search = nil
local lb = {}
local lb_gui = {}
self_.curSelected = nil

local function getNumSlots()
	local num = #lb
	if num > maxSlots then
		return maxSlots
	else
		return num
	end
end

local function LeaderboardSlot(data,slotNum)
	return Roact.createElement("ImageButton", {
		Size = UDim2.new(0.96,0,0,70);
		BackgroundColor3 = Color3.fromRGB(17, 17, 17);
		Position = UDim2.new(0,0,0,(slotNum-1)*72);
		BorderSizePixel = 0;
		[Roact.Event.MouseButton1Click] = function(rbx)
			local data =  {
				marv = data.marv;
				perf = data.perf;
				great = data.great;
				good = data.good;
				okay = data.okay;
				miss = data.miss;
				total = self_.curSelected:GetObjectNumber();
				acc = data.accuracy;
				score = data.score;
				chain = 0;
				maxcombo = data.combo;
				playername = data.username;
				playerid = data.userid;
				song = self_.curSelected;
				songlen = self_.curSelected:GetLength()/1000;
				rate = data.rate;
				datetime = DateTime:GetDateTime(data.epochtime);
			}
		end
	}, {
		SlotNumber = Roact.createElement("TextLabel", {
			Text = tostring(slotNum)..".";
			TextColor3 = Color3.new(1,1,1);
			TextScaled = true;
			BackgroundTransparency = 1;
			Position = UDim2.new(0.02,0,0.05,0);
			Size = UDim2.new(0.07,0,0.35,0);
			Font = Enum.Font.GothamBlack;
		});
		PlayerName = Roact.createElement("TextLabel", {
			TextXAlignment = Enum.TextXAlignment.Left;
			Text = data.username;
			TextColor3 = Color3.new(1,1,1);
			TextScaled = true;
			BackgroundTransparency = 1;
			Position = UDim2.new(0.1,0,0.05,0);
			Size = UDim2.new(0.875,0,0.35,0);
			Font = Enum.Font.GothamBlack;
		});
		PlayData=Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5,0);
			Text = "Rating: " .. Math.round(data.rating,2) .. " | Score: " .. Math.round(data.score) .. " | Accuracy: " .. Math.round(data.accuracy,2) .. "%";
			TextXAlignment = Enum.TextXAlignment.Left;
			TextColor3 = Color3.new(1,1,1);
			TextScaled = true;
			BackgroundTransparency = 1;
			Position = UDim2.new(0.5,0,0.425,0);
			Size = UDim2.new(0.94,0,0.5,0);
			Font = Enum.Font.GothamBlack;
		});
	})
end

local function SongButtons(props)
	local ret = {}	
	for i, button in pairs(self_.SongButtons) do
		local song = button.props.song
		local doAdd = Search:find(song:ConcatMetadata(), props.search)
		if doAdd then ret[#ret+1] = button end
	end
	return Roact.createFragment(ret), #ret
end

local function Leaderboard()
	table.sort(lb, Sorts.Leaderboard)

	local lb_gui = {}
	for i, slot in pairs(lb) do
		if i > maxSlots then break end
		lb_gui[#lb_gui+1] = LeaderboardSlot(slot, i)
	end
	return Roact.createFragment(lb_gui)
end

function SongSelectScreen:init()
	local bttns = {}
	for i, v in pairs(songs) do
		bttns[i] = Roact.createElement(SongButton, {
			song = v;
			songNum = i;
			changeSong = function()
				self.props.changeSong(v)
			end
		})
	end

	local kbpool = self_.Keybinds

	kbpool:AddKeybinds({
		Keybind:listen(Enum.KeyCode.Minus, function()
			local settings = self.props.settings
			local curRate = settings.Rate
			curRate = curRate - settings.RateIncrement
			self.props.changeSetting("Rate", curRate)
		end),
		Keybind:listen(Enum.KeyCode.Equals, function()
			local settings = self.props.settings
			local curRate = settings.Rate
			curRate = curRate + settings.RateIncrement
			self.props.changeSetting("Rate", curRate)
		end)
	})

	self_.SongButtons = bttns

	self.props.changeSong(songs[1])
end

function SongSelectScreen:render()
	local rate = self.props.settings.Rate

	local rate_s = "Song Rate: " .. rate .. "x"
	
	rateMult = Metrics:CalculateRateMult(rate or 1)

	local length = self.props.curSelected:GetLength()
	local dtTime = DateTime:GetDateTime((length/1000)/rate)
	local songLength = dtTime:format("Song Length: #m:#s")

	local sbuttons, found = SongButtons({
		songs = songs;
		search = search or nil
	})

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
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Crop,
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
						Text = self.props.curSelected:GetArtist();
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
						Text = self.props.curSelected:GetSongName();
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
					Text = rate_s;
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
			Leaderboards = Roact.createElement("Frame", {
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
					Leaderboard = Roact.createElement(Leaderboard);
				});
			}),
			--[[NpsGraph = Roact.createElement(, {
				Size = UDim2.new(0.27,0,0.35,0),
				Anchor = Vector2.new(0.5,1),
				Position = UDim2.new(0.45,0,0.99,0),
				BSizePixel = 0,
				ZIndex = 2,
			}),]]--
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
					CanvasSize = UDim2.new(0,0,0,found*60);
					VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right;
					ScrollBarThickness = 6,
					BorderSizePixel = 0,
					TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
					BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
				}, {
					Layout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
					}),
					Buttons = sbuttons;
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
					if true then
						local settings = self.props.settings
						local curRate = settings.Rate
						curRate = curRate - settings.RateIncrement
						self.props.changeSetting("Rate", curRate)
						return
					end
					FastSpawn(function()
						local g = Game:new()
						self_:Unmount()
						local rate = Settings.Options.Rate
						local note_color_opt = Settings.Options.NoteColor
						local noteColor = Color:convertHSV(note_color_opt)
						g:StartGame(self_.curSelected, rate, Settings.Options.Keybinds, noteColor, Settings.Options.ScrollSpeed)


						local gamejoin=g._local_services._game_join;
						local localgame=g.local_game;
						local gamelua=g;

						local songlen = gamejoin:get_songLength()/1000
						local data = gamejoin:get_data()

						--_marv_count,_perfect_count,_great_count,_good_count,_ok_count,_miss_count,_total_count,self_:get_acc(),self_._score,self_._chain,_max_chain
						
						Screens:FindScreen("ResultsScreen"):DoResults({
							marv = data[1];
							perf = data[2];
							great = data[3];
							good = data[4];
							okay = data[5];
							miss = data[6];
							total = data[7];
							acc = data[8];
							score = data[9];
							chain = data[10];
							maxcombo = data[11];
							npsgraph = gamejoin:GetMsDeviance();
							playername = LocalPlayer.Name;
							playerid = LocalPlayer.UserId;
							song = self_.curSelected;
							songlen = songlen;
							rate = rate;
						}, not g.force_quit)
						g:DestroyStage()
						g:DestroyGame()
					end)
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