local RunService = game:GetService("RunService")

local Boundary = {}
Boundary.Server = {}
Boundary.Client = {}

--// CLIENT METHODS:

function Boundary.Client:Execute(name, ...)
    local r = script:WaitForChild(name, 5)
    if r ~= nil then
        return r:InvokeServer(...)
    end
    return nil
end

function Boundary.Client:Listen(name, callback)
    local r = script:WaitForChild(name)
    if r ~= nil then
        r.OnClientInvoke = callback
    end
    return nil
end

--// SERVER METHODS:

function Boundary.Server:Register(name, callback)
    local rf = Instance.new("RemoteFunction")
    rf.Name = name
    rf.OnServerInvoke = callback or (function()end)
    rf.Parent = script
end

function Boundary.Server:Execute(name, plr, ...)
    local r = script:WaitForChild(name, 5)
    if r ~= nil then
        return r:InvokeClient(plr, ...)
    end
    return nil
end

return Boundary