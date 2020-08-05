local RunService = game:GetService("RunService")

local SongObject = require(script.Parent.SongObject)
local AllSongs = game.ReplicatedStorage:WaitForChild("LocalStorage"):WaitForChild("Songs")
local TestSongs = game.ReplicatedStorage:WaitForChild("TestSongs", 5)

local Songs = {
	AllSongs = {}
}

function Songs:GetAllSongs()
	return self.AllSongs
end

function Songs:Initialize()
	local sgs = {}
	for i, song in pairs(AllSongs:GetChildren()) do
		sgs[#sgs+1] = SongObject:new(song)
	end
	if RunService:IsStudio() and TestSongs ~= nil then
		for i, song in pairs(TestSongs:GetChildren()) do
			sgs[#sgs+1] = SongObject:new(song)
		end
	end
	self.AllSongs = sgs
end

return Songs
