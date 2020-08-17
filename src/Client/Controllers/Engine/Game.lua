-- Game
-- kisperal 
-- August 15, 2020



local Game = {}

local ObjectPool = require(script.Parent.ObjectPool)

function Game:new(properties)
    local localGame = {
        services = {
            ObjectPool = ObjectPool:new({
                scrollSpeedMs = properties.scrollSpeedMs;
                hitObjects = properties.song.data.HitObjects;
                keybinds = properties.keybinds;
            });
        }
    }

    --[[
        properties = {
            song = {
                <methods>
                <properties>
                AudioAssetId
                AudioArtistName
            }
        }
    ]]--

    function localGame:LoadSong()
        local sound: Sound = Instance.new("Sound")
        sound.SoundId = properties.song.AudioAssetId
    end

    function localGame:PlaySong()

    end

    function localGame:GetSongTime()

    end

    function localGame:GetTimeToEnd()

    end

    function localGame:GetCurrentVelocity()

    end

    function localGame:GetSong()

    end

    function localGame:Quit()
        
    end

    return localGame
end

return Game