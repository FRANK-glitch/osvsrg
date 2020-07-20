local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)
local FastSpawn = require(game.ReplicatedStorage.FastSpawn)
local DateTime = require(game.ReplicatedStorage.DateTime)
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
	
local maxSlots = 50

local rateMult = 1

local search = nil
local lb = {}
local lb_gui = {}
self.curSelected = songs[1]
local mapname = ""
local diffname = ""
local artistname = ""

local tree = {}
local handle = {}

local function getNumSlots()
	local num = #lb
	if num > maxSlots then
		return maxSlots
	else
		return num
	end
end

local rateBinding, changeRateBinding = Roact.createBinding(Settings.Options.Rate)

local screenBinds = {
	Keybind:listen(Enum.KeyCode.Equals, function()
		local newValue = Settings:Increment("Rate", Settings.Options.SongSelectRateIncrement, {
			min = 0.5;
			max = 5;
		})
		changeRateBinding(newValue)
		self:Redraw()
	end);
	Keybind:listen(Enum.KeyCode.Minus, function()
		local newValue = Settings:Increment("Rate", -Settings.Options.SongSelectRateIncrement, {
			min = 0.5;
			max = 5;
		})
		changeRateBinding(newValue)
		self:Redraw()
	end)
}

for i, bind in pairs(screenBinds) do
	bind:stop()
end

local function SongButton(instance, song, songNum)
	return Roact.createElement("ImageButton", {
		Size = UDim2.new(0.975,0,0,60);
		BackgroundColor3 = song:GetButtonColor();
		Position = UDim2.new(0,0,0,(songNum-1)*60);
		Image = "";
		BorderSizePixel = 0;
		[Roact.Event.MouseButton1Click] = function()
			self.curSelected = song
			self:UpdateLeaderboard()
			self:UpdateMapInfo()
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
			Text = "["..Math.avg(tonumber(song:GetDifficulty())*rateMult).."]",
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

local function getNPSGraph(props)
	local graph = Graph.new("Bar")
	if self.curSelected ~= nil then
		local lowColor = Color3.fromRGB(237, 255, 148)
		local highColor = Color3.fromRGB(255, 0, 191)
		local maxColorNps = 32
		local c = self.curSelected
		local n = c:GetNpsGraph()
		local r = Settings.Options.Rate or 1
		graph.xfloor = 0
		graph.xceiling = math.floor(c:GetLength()/1000)/r
		graph.xinterval = 30
		graph.yceiling = (Math.findMax(n)+5)*r
		graph.yfloor = 0
		graph.yinterval = math.floor(graph.yceiling/5)
		for i, v in pairs(n) do
			v = v*r
			graph:AddObject(i, v, lowColor:lerp(highColor, math.clamp(v/maxColorNps, 0, 1)))
		end
	end
	return Roact.createElement(graph.component, props)
end

local function LeaderboardSlot(data,slotNum)
	return Roact.createElement("ImageButton", {
		Size = UDim2.new(0.96,0,0,70);
		BackgroundColor3 = Color3.fromRGB(17, 17, 17);
		Position = UDim2.new(0,0,0,(slotNum-1)*72);
		BorderSizePixel = 0;
		[Roact.Event.MouseButton1Click] = function(rbx)
			self:Unmount()
			Screens:FindScreen("ResultsScreen"):DoResults({
				marv = data.marv;
				perf = data.perf;
				great = data.great;
				good = data.good;
				okay = data.okay;
				miss = data.miss;
				total = self.curSelected:GetObjectNumber();
				acc = data.accuracy;
				score = data.score;
				chain = 0;
				maxcombo = data.combo;
				playername = data.username;
				playerid = data.userid;
				song = self.curSelected;
				songlen = self.curSelected:GetLength()/1000;
				rate = data.rate;
				datetime = DateTime:GetDateTime(data.epochtime);
			})
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
	local bttns = {}	
	for i, song in pairs(props.songs) do
		local doAdd = Search:find(song:ConcatMetadata(), props.search)
		if doAdd then bttns[#bttns+1] = SongButton(song.instance, song, i) end
	end
	return Roact.createFragment(bttns), #bttns
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

local function Base()
	rateMult = Metrics:CalculateRateMult(Settings.Options.Rate or 1)
	local sbuttons, found = SongButtons({
		songs = songs;
		search = search or nil
	})
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
						Text = artistname;
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
						Text = mapname;
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
						Text = diffname;
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
					Text = rateBinding:map(function(rate)
						local length = self.curSelected:GetLength()
						local dtTime = DateTime:GetDateTime((length/1000)/rate)
						local formatted = dtTime:format("Song Length: #m:#s")
						return formatted
					end);
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
					Text = rateBinding:map(function(rate)
						return string.format("Song Rate: %0.2fx", rate)
					end);
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
						tree = Base()
						Roact.update(handle,tree)
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
			NpsGraph = getNPSGraph({
				Size = UDim2.new(0.27,0,0.35,0),
				Anchor = Vector2.new(0.5,1),
				Position = UDim2.new(0.45,0,0.99,0),
				BSizePixel = 0,
				ZIndex = 2,
			}),
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
					FastSpawn(function()
						local g = Game:new()
						self:Unmount()
						local rate = Settings.Options.Rate
						local note_color_opt = Settings.Options.NoteColor
						local noteColor = Color:convertHSV(note_color_opt)
						g:StartGame(self.curSelected, rate, Settings.Options.Keybinds, noteColor, Settings.Options.ScrollSpeed)


						local gamejoin=g._local_services._game_join;
						local localgame=g.local_game;
						local gamelua=g;

						local songlen = gamejoin:get_songLength()/1000
						local data = gamejoin:get_data()

						--_marv_count,_perfect_count,_great_count,_good_count,_ok_count,_miss_count,_total_count,self:get_acc(),self._score,self._chain,_max_chain
						
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
							song = self.curSelected;
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

function self:DoSongSelect()
	changeRateBinding(Settings.Options.Rate)
	for i, bind in pairs(screenBinds) do
		bind:begin()
	end
	Logger:Log("Entering song select...")
	tree = Base()
	handle = Roact.mount(tree, PlayerGui, "SongSelect")
	Logger:Log("Song select screen mounted!")
end

function self:Redraw()
	tree = Base()
	Roact.update(handle,tree)
end

function self:Unmount()
	for i, bind in pairs(screenBinds) do
		print("Stopping bind...")
		bind:stop()
	end
	Roact.unmount(handle)
	Logger:Log("Song select screen unmounted!")
end

function self:UpdateLeaderboard()
	Logger:Log("Leaderboard updated...")
	spawn(function()
		lb = Online:GetMapLeaderboard(self.curSelected:GetId())
		tree = Base()
		Roact.update(handle,tree)
	end)
end
function self:UpdateMapInfo()
	Logger:Log("Map info updated...")
	spawn(function()
		mapname = self.curSelected:GetSongName()
		artistname = self.curSelected:GetArtist()
		if self.curSelected:GetDifficultyName() == nil then
			diffname = "["..(Math.avg(tonumber(self.curSelected:GetDifficulty()) + 0.5)*rateMult).."]"
		else
			diffname = "["..(Math.avg(tonumber(self.curSelected:GetDifficulty()) + 0.5)*rateMult).."] "..self.curSelected:GetDifficultyName()
		end
		tree = Base()
		Roact.update(handle,tree)
	end)
end

return self