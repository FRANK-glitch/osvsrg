local Localization = game:GetService("LocalizationService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Boundary = require(ReplicatedStorage.Frameworks.Boundary)
local Http = require(ReplicatedStorage.Helpers.Http)
local Api = Http.withBaseEndpoint("https://robeatscsgame.com/api")

--local Anticheat = require(ReplicatedStorage.Anticheat)

--[[
{
	["Content-Type"] = "application/json";
}
]]--
---------------------

function calculateRating(rate, acc, difficulty)
	local ratemult = 1
	if rate then
		if rate >= 1 then
			ratemult = 1 + (rate-1) * 0.6
		else
			ratemult = 1 + (rate-1) * 2
		end
	end
	return ratemult * ((acc/97)^4) * difficulty
end

local function getAvatarUrl(p_ID)
	local uri = game:GetService("Players"):GetUserThumbnailAsync(p_ID, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	return uri
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

Boundary.Server:Register("SubmitScore", function(player, data)
	local RBLXLeaderstats = player:WaitForChild("leaderstats")
	data.userid = player.UserId
	data.username = player.Name
	return Api:Request("/score", "POST", Http:Serialize(data), {
		["Content-Type"] = "application/json";
	}).DecodedBody
end)

Boundary.Server:Register("GetMapLB", function(player, m_ID)
	return Api:Request("/maps/"..m_ID, "GET", nil, {
		["Content-Type"] = "application/json";
	}).DecodedBody
end)

Boundary.Server:Register("GetUserPlays", function(player, data)
	return Api:Request("/users/"..player.UserId, "GET", nil, {
		["Content-Type"] = "application/json";
	}).DecodedBody
end)


--[[local function CalculatePlayerRating(p_ID)
	local maps = game.ReplicatedStorage:WaitForChild("Songs")
	local ratings = {}
	local names = {}
	local rating = 0
	local maxNumOfScores = 25
	table.sort(ratings, function(a,b)
		return a > b
	end)
	for i, r in pairs(ratings) do
		if (not (i > maxNumOfScores)) then
			if i <= 10 then
				rating = rating + r * 1.5
			else
				rating = rating + r
			end
		end
	end
	local plr_rating = math.floor(100 * rating / 30) / 100
	return plr_rating
end]]--
