-- Logger
-- kisperal 
-- August 14, 2020

local RunService = game:GetService("RunService")

local Logger = {}

local data = {
    studio = RunService:IsStudio();
    client = RunService:IsClient();
    server = RunService:IsServer();
}

local function stringConditionalChain(...)
    local o = ""

    for i, v in pairs({...}) do
        if v[1] then
            o ..= v[2] .. (not v[3]) and " "
        end
    end

    return o
end

local prefix = stringConditionalChain({data.studio, "[STUDIO]"}, {data.client, "[CLIENT]"}, {data.server, "[SERVER]"})

local function put(str)
    print(prefix .. str)
end

function Logger:Log(str)
    put(str)
end

function Logger:Warn(str)
    put(">>>>WARNING<<<< " .. str)
end

function Logger:Error(str)
    put(">>>>ERROR<<<< " .. str)
end

function Logger:Fatal(str)
    error(">>>>FATAL<<<< " .. str)
end

function Logger:Start()
    put("Logger module started!")
end

return Logger