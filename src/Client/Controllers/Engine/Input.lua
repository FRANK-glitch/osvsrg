-- Input
-- kisperal 
-- August 17, 2020

local Input = {PressedPool = {}, ReleasedPool = {}}

function Input:KeyJustPressed(keyCode)
    if self.PressedPool[keyCode.Value] then
        self.PressedPool[keyCode.Value] = nil
        return true
    end
    return false
end

function Input:KeyJustReleased(keyCode)
    if self.ReleasedPool[keyCode.Value] then
        self.ReleasedPool[keyCode.Value] = nil
        return true
    end
    return false
end

function Input:Init()
    local UserInput = self.Controllers.UserInput
    local Keyboard = UserInput:Get("Keyboard")

    Keyboard.KeyDown:Connect(function(keyCode)
        self.PressedPool[keyCode.Value] = true
    end)

    Keyboard.KeyUp:Connect(function(keyCode)
        self.ReleasedPool[keyCode.Value] = true
    end)
end

return Input