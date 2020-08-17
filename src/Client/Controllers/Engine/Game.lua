-- Game
-- kisperal 
-- August 15, 2020



local Game = {}

function Game:new(properties)
    local localGame = {}

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