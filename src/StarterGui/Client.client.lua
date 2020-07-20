--[[

CLIENT.LUA

CLIENT SIDE LOGIC FOR ROBEATS CS

--]]

repeat wait() until game.Players.LocalPlayer.Character ~= nil
game.Players.LocalPlayer.Character:Destroy()
game.Players.LocalPlayer.Character = nil
local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Utils = script.Parent:WaitForChild("Utils")
local ScreenUtil = require(Utils.ScreenUtil)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))

Cmdr:SetActivationKeys({ Enum.KeyCode.BackSlash })

for i, screen in pairs(PlayerGui:WaitForChild("Screens"):GetChildren()) do
	ScreenUtil:NewScreen(screen.Name, require(screen))
end

ScreenUtil:FindScreen("MainMenuScreen"):DoOptions()

--local Utils = game:GetService("StarterGui").Utils  local SongObject = require(Utils.SongObject)  local song = SongObject:new(game.ReplicatedStorage:WaitForChild("Songs"):WaitForChild("[396] Camellia - PLANET SHAPER (Evening)"))  print(require(Utils.CSCalc):DoRating(song))