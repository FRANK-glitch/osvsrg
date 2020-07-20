-- TODO: make this module rate limit itself so it doesnt like spam the database or anything like that

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Boundary  = require(ReplicatedStorage.Frameworks.Boundary)

local Utils = script.Parent
local Logger = require(Utils.Logger):register(script)

local r = game.ReplicatedStorage
local m = r:WaitForChild("Misc")

local _mcache = {}
local _curSelected = nil

local Online = {}

function Online:GetMapLeaderboard(m_ID)
	_curSelected = m_ID
	wait(0.55)
	if m_ID ~= _curSelected then return {} end

	local retrieveNew = false

	local o = _mcache[m_ID]

	if o ~= nil then
		if tick() - o.t > 15 then
			retrieveNew = true
		end
	else
		retrieveNew = true
	end
	local r = retrieveNew and Boundary.Client:Execute("GetMapLB", m_ID) or _mcache[m_ID].lb
	if retrieveNew then
		_mcache[m_ID] = {
			lb = r;
			t = tick();
		}
	end

	Logger:Log(retrieveNew and "Retrieving new leaderboard from the web server..." or "Using cache...")

	return r
end

function Online:GetPlayerPlays()
	return m.GetTopPlays:InvokeServer()
end

function Online:GetGlobalLeaderboard()
	return m.GetGlobalLeaderboard:InvokeServer()
end

function Online:SubmitScore(pkg_data)
	m.SubmitScore:InvokeServer(pkg_data)
end

return Online
