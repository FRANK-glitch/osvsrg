local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local ServerScripts = script.Parent
local ServerClasses = ServerScripts.ServerClasses

local MultiRoom = require(ServerClasses.MultiplayerRoom)

local Boundary = require(ReplicatedStorage.Frameworks.Boundary)
local BoundaryServer = Boundary.Server

local Games = {}

local function add(tab, item)
    tab[#tab+1] = item
end

local function remove(tab, rmFn)
    for i, v in pairs(tab) do
        if rmFn(v) == true then
            v = nil
        end
    end
end

BoundaryServer:Register("GetMultiGames", function(player)
    return Games
end)

BoundaryServer:Register("CreateNewRoom", function(player)
    local room = MultiRoom:new()
    room.host = player
    room:AddPlayer(player)
    add(Games, room)
    print(HttpService:JSONEncode(room))
end)

BoundaryServer:Register("JoinRoom", function(player)
    
end)

BoundaryServer:Register("LeaveRoom", function(player)

end)
