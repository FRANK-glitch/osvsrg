local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Boundary = require(ReplicatedStorage.Frameworks.Boundary)
local BoundaryServer = Boundary.Server

local MultiplayerRoom = {}

function MultiplayerRoom:new()
    local room = {}

    room.id = HttpService:GenerateGUID(false)
    room.song = nil
    room.players = {}
    room.host = {}
    room.isplaying = false
    room.mods = {}

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

    function room:AddPlayer(plr)
        add(room.players, plr)
    end

    function room:RemovePlayer(plr)
        remove(room.players, function(item)
            return plr.UserId == item.UserId
        end)
    end

    function room:ApplyMod(mod)
        add(room.mods, mod)
    end

    function room:UnapplyMod(mod)
        remove(room.mods, function(item)
            return item.Name == mod.Name
        end)
    end

    function room:ChangeSong(song)
        room.song = song
    end
    
    function room:StartGame()
        room.isplaying = true
    end

    function room:StopGame()
        room.isplaying = true
    end

    return room    
end

return MultiplayerRoom
