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
local RoduxGameStore = require(Utils.RoduxGameStore)
local Settings = require(Utils.Settings)
local Online = require(Utils.Online)
local Logger = require(Utils.Logger):register(script)
local Anticheat = require(Utils.Anticheat)
local CurrentCamera = workspace.CurrentCamera

local Utils = script.Parent
local Screens = require(Utils.ScreenUtil) 

local RunService = game:GetService("RunService")
local s = game.ReplicatedStorage.Spectating

local roduxStore = RoduxGameStore.store

EnvironmentSetup:initial_setup(game.Players.LocalPlayer, workspace.CurrentCamera)

local Game = {
	LocalServices = {};
	LocalGame = {};
	ForceQuit = false;
	SongDone = false;
	HeartbeatConnection = nil;
	GameLoaded = false;
}
	
function Game:StartGame(song, settings)
	self.GameLoaded = false;
	local rate, keys, note_color, scroll_speed, combo = settings.Rate, settings.Keybinds, Color3.new(1,1,1), settings.ScrollSpeed or 20, 0
	--[[
		{
			Settings:GetOption("ShowMisses");
			Settings:GetOption("ShowBads");
			Settings:GetOption("ShowGoods");
			Settings:GetOption("ShowGreats");
			Settings:GetOption("ShowPerfs");
			Settings:GetOption("ShowMarvs");
		},
	]]--
	local fov = 60 
	CurrentCamera.FieldOfView = settings.FieldOfView or 70

	--// START INITAL SETUP

	self.LocalServices = {
		_spui = SPUISystem:new(5);
		_game_join = GameJoin:new(combo);
		_input = InputUtil:new(keys);
		_sfx_manager = SFXManager:new(EnvironmentSetup:get_element());
		_object_pool = ObjectPool:new(EnvironmentSetup:get_element());
		_update_enqueue_fn = EnqueueFn:new();
		hit_cache = HitCache:new()
	}
	self.LocalServices._game_join:game_init(self.LocalServices, EnvironmentSetup:get_environment(), false)
	wait()
	self.LocalGame = self.LocalServices._game_join:load_game(
		self.LocalServices,
		song,
		rate,
		scroll_speed,
		EnvironmentSetup:get_environment(),
		EnvironmentSetup:get_protos(), 
		EnvironmentSetup:get_element(),
		note_color,
		0, 
		0,
		{},
		nil,
		ModManager:GetActivatedMods() or {},
		combo
	)

	Logger:Log("Game currently loading...")
	
	repeat wait() until self.LocalGame:is_ready() and self.LocalServices._game_join:is_game_audio_loaded()
	self.GameLoaded = true
	Logger:Log("Game loaded!")
	Logger:Log("Starting game...")
	self.LocalServices._game_join:start_game(EnvironmentSetup:get_protos())
	Logger:Log("Game started!")

	local songLength = self.LocalServices._game_join:get_songLength()/1000

	self.HeartbeatConnection = RunService.Heartbeat:Connect(function(tickDelta)
		local dt_scale = CurveUtil:DeltaTimeToTimescale(tickDelta)

		self.LocalServices._game_join:update(dt_scale)
		self.LocalServices._spui:layout()
		self.LocalServices._update_enqueue_fn:update(dt_scale)

		self.LocalServices._sfx_manager:update(dt_scale,self.LocalServices)
		self.LocalServices._input:post_update()

		local data = self.LocalServices._game_join:get_data()

		self.SongDone = self.LocalServices._game_join:check_songDone()

		--_marv_count,_perfect_count,_great_count,_good_count,_ok_count,_miss_count,_total_count,self:get_acc(),self._score,self._chain,_max_chain
		roduxStore:dispatch({
			type = "updateStats",
			score = data[9];
			combo = data[10];
			maxcombo = data[11];
			marvs = data[1];
			perfs = data[2]; 
			greats = data[3];
			goods = data[4];
			bads = data[5];
			miss = data[6];
			accuracy = data[8];
			total = data[7];
		})

		if self.SongDone or self.ForceQuit then
			Game:EndGame(self.ForceQuit)
		end
	end)
end
function Game:EndGame(forceQuit)
	repeat wait() until self.GameLoaded
	self.HeartbeatConnection:Disconnect()
	self.ForceQuit = not not forceQuit
	self:DestroyStage()
end
function Game:DestroyStage()
	self.GameLoaded = false
	self.LocalServices._game_join:finishGame()
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
function Game:PostPlay()
	--[[local hits = self.LocalServices.hit_cache.hits
	local testCase = Anticheat:NewCase(song, hits)
	local cheated = testCase:RunPipeline()
	if cheated then
		Logger:Log("Cheating detected!")
		game.Players.LocalPlayer:Kick("Cheating detected!")
	end]]--
end

return Game
