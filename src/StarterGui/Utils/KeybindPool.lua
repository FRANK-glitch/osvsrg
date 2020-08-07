local KeybindPool = {}

function KeybindPool:new()
    local pool = {}

    pool.pool = {}

    function pool:AddKeybinds(keybinds)
        self.pool = keybinds
    end

    function pool:ListenAll()
        for i, v in pairs(self.pool) do
            v:begin()
        end
    end

    function pool:UnlistenAll()
        for i, v in pairs(self.pool) do
            v:stop()
        end
    end

    return pool
end

return KeybindPool
