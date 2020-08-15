-- State Controller
-- kisperal
-- August 14, 2020



local StateController = {}


function StateController:Start()
	
end

function StateController:Init()
    local RoactRodux = self.Shared.RoactRodux
    local Rodux = self.Shared.Rodux
    local Llama = self.Shared.Llama
    local reducer = Rodux.createReducer(self.Modules.Metadata.InitialState, {
        modifySetting = function(state, action)
            return Llama.Dictionary.join(state, {
                Settings = Llama.Dictionary.join(state.Settings, {
                    [action.setting] = action.value
                })
            })
        end;
        switchScreen = function(state, action)
            return Llama.Dictionary.join(state, {
                curScreen = action.screen
            })
        end;
        switchSong = function(state, action)
            return Llama.Dictionary.join(state, {
                curSelected = action.song
            })
        end;
        updateStats = function(state, action)
            return Llama.Dictionary.join(state,{
                SongStats = Llama.Dictionary.join(state.SongStats, {
                    score = action.score;
                    combo = action.combo;
                    maxcombo = action.maxcombo;
                    marvs = action.marvs;
                    perfs = action.perfs;
                    greats = action.greats;
                    goods = action.goods;
                    bads = action.bads;
                    miss = action.misses;
                    accuracy = action.accuracy;
                    total = action.total;
                })   
            })
        end
    });
    
    self.RoduxStore = Rodux.Store.new(reducer)
    self.RoactRoduxConnection = RoactRodux.connect(
        function(state, props)
            return state
        end,
        function(dispatch)
            return {
                switchScreens = function(screen)
                    dispatch({
                        type = "switchScreen";
                        screen = screen;
                    })
                end;
                changeSong = function(song)
                    dispatch({type = "switchSong", song = song})
                end;
                changeSetting = function(setting, value)
                    dispatch({type = "modifySetting", setting = setting, value = value})
                end;
            }
        end
    )
end

function StateController:GetStore()
    return self.RoduxStore
end


return StateController