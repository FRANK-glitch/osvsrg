local dir = game.ReplicatedStorage:WaitForChild("Engine")
local SPUtil = require(dir.Shared.SPUtil)
local DebugOut = require(dir.Local.DebugOut)
local SFXManager = require(dir.Local.SFXManager)
local ObjectPool = require(dir.Local.ObjectPool)
local EffectSystem = require(dir.Effects.EffectSystem)
local InputUtil = require(dir.Shared.InputUtil)
local CurveUtil = require(dir.Shared.CurveUtil)
local EnvironmentSetup = require(dir.LocalShared.EnvironmentSetup)
local GameJoin = require(dir.Local.GameJoin)
local SPUISystem = require(dir.Shared.SPUISystem)
local EnqueueFn = require(dir.Shared.EnqueueFn)
local HitCache = require(dir.Local.HitCache)
local ModManager = require(game.ReplicatedStorage.ModManager)

local Utils = script.Parent
local Settings = require(Utils.Settings)
local Online = require(Utils.Online)
local Logger = require(Utils.Logger):register(script)
local Anticheat = require(Utils.Anticheat)
local CurrentCamera = workspace.CurrentCamera

local Utils = script.Parent
local Screens = require(Utils.ScreenUtil) 

local RunService = game:GetService("RunService")
local s = game.ReplicatedStorage.Spectating

EnvironmentSetup:initial_setup(game.Players.LocalPlayer, workspace.CurrentCamera)

local Game = {}

function Game:new()
	local g = {}
	g._local_services = {}
	g.local_game = {}
	g.force_quit = false
	function g:StartGame(song, rate, keys, note_color, scroll_speed, combo)
		local fov = Settings.Options.FOV
		Logger:Log("Current FOV: " .. fov .. ", applying...")
		CurrentCamera.FieldOfView = fov
		Logger:Log("FOV applied!")
		Logger:Log("Setting up gameplay...")
		local GameplayScreen = Screens:FindScreen("GameplayScreen")
		local _local_services = {}
		_local_services = {
			_spui = SPUISystem:new(5);
			_game_join = GameJoin:new(combo);
			_input = InputUtil:new(keys);
			_sfx_manager = SFXManager:new(EnvironmentSetup:get_element());
			_object_pool = ObjectPool:new(EnvironmentSetup:get_element());
			_update_enqueue_fn = EnqueueFn:new();
			hit_cache = HitCache:new()
		}
		g._local_services = _local_services
		_local_services._game_join:game_init(_local_services, EnvironmentSetup:get_environment(), false)
		wait()
		local localGame = _local_services._game_join:load_game(
			_local_services,
			song,
			rate,
			scroll_speed,
			EnvironmentSetup:get_environment(),
			EnvironmentSetup:get_protos(), 
			EnvironmentSetup:get_element(),
			note_color,
			0, 
			0,
			{
				Settings:GetOption("ShowMisses");
				Settings:GetOption("ShowBads");
				Settings:GetOption("ShowGoods");
				Settings:GetOption("ShowGreats");
				Settings:GetOption("ShowPerfs");
				Settings:GetOption("ShowMarvs");
			},
			nil,
			ModManager:GetActivatedMods() or {},
			combo
		)
		g.local_game = localGame

		Logger:Log("Game currently loading...")
		
		local function getCurrentGameStatus()
			local plr = game.Players.LocalPlayer
			if plr then
				return game.ReplicatedStorage.Spectating.GetGame:InvokeServer(plr)
			end
		end
		
		local hC = localGame._hit_cache
		
		s.GetGame.OnClientInvoke = function()
			return {
				hits=hC.hits
			}
		end
		
		local function getTime()
			return _local_services._game_join:get_songTime()
		end
		
		repeat wait() until localGame:is_ready() and _local_services._game_join:is_game_audio_loaded()

		Logger:Log("Game loaded!")
		Logger:Log("Starting game...")
		_local_services._game_join:start_game(EnvironmentSetup:get_protos())
		Logger:Log("Game started!")
		local isDone = false
		
		local tries = 0	
		
		local timeSinceLast = 0
		local selfgamedata = nil
		
		
		local function handleSpectators()
			--[[local timeNow = getTime()
			if timeNow - timeSinceLast > 2500 then
				timeSinceLast = timeNow
				selfgamedata = getCurrentGameStatus()
				if selfgamedata then
					for i, ob in pairs(Spectators:GetChildren()) do
						if ob.Name == script.Spectator.Name then
							ob:Destroy()
						end
					end
					for i, plr_ in pairs(selfgamedata.spectators) do
						local ob = script.Spectator:Clone()
						ob.Text = plr_.Name
						ob.Parent = Spectators
					end
				end
			end--]]
		end

		local hasInit = false

		local function getProperties()
			return {
				Data=localGame:get_data();
				Song=song;
				Rate=rate;
			}
		end

		local function UpdateScreen()
			local props = getProperties()
			if not hasInit then
				hasInit = true
				GameplayScreen:Initialize(props, g)
				return
			end
			GameplayScreen:Update(props)
		end

		local function Unmount()
			GameplayScreen:Unmount()
		end
		
		local checkCount = 1
		local songTime = 0
		local rawTime = 0
		local songLength = _local_services._game_join:get_songLength()/1000
		local timeLeft = 0
		local timeText = ""
		local prevTimeLeft = 0

		local timeSince = 0

		while isDone == false and g.force_quit == false do
			local tickDelta = RunService.Heartbeat:wait()
			local dt_scale = CurveUtil:DeltaTimeToTimescale(tickDelta)

			_local_services._game_join:update(dt_scale)
			_local_services._spui:layout()
			_local_services._update_enqueue_fn:update(dt_scale)
	
			_local_services._sfx_manager:update(dt_scale,_local_services)
			_local_services._input:post_update()
			rawTime = _local_services._game_join:get_songTime()
			songTime = rawTime/1000
			isDone = _local_services._game_join:check_songDone()

			if rawTime - timeSince >= 50 then
				timeSince = rawTime
				UpdateScreen()
			end
		end

		local hits = _local_services.hit_cache.hits
		local testCase = Anticheat:NewCase(song, hits)
		local cheated = testCase:RunPipeline()
		if cheated then
			Logger:Log("Cheating detected!")
			game.Players.LocalPlayer:Kick("Cheating detected!")
		end
		Logger:Log("Game complete! Unmounting...")
		Unmount()
		Logger:Log("Unmount successful!")
	end
	function g:DestroyStage()
		Logger:Log("Destroying stage...")
		g._local_services._game_join:finishGame()
		local so = workspace.CurrentCamera:GetChildren()
		for i=1, #so do
			if so[i].Name ~= "LocalElements" and so[i].Name ~= "GameEnvironment" then
				so[i]:Destroy()
			elseif so[i].Name == "LocalElements" then
				local lo = so[i]:GetChildren()
				for j=1, #lo do
					lo[j]:Destroy()
				end
			elseif so[i].Name == "GameEnvironment" then
				so[i].Parent = nil
			end
		end
		Logger:Log("Stage destroyed successfully!")
	end
	function g:DestroyGame()
		g = nil
	end
	function g:GetGame()
		return g.local_game
	end
	function g:GetLocalServices()
		return g._local_services
	end
	return g
end

return Game
