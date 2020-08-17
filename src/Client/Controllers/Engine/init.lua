-- Engine
-- kisperal 
-- August 15, 2020



local Engine = {}

local modules = {}

local function get(name)
	return modules[name]
end

function Engine:NewGame(settings)
	local _game = get("Game"):new()
	self.currentGame = _game
	return self.currentGame
end

function Engine:Init()
	for _,obj in ipairs(script:GetChildren()) do
		if (obj:IsA("ModuleScript")) then
			local module = require(obj)
			self:WrapModule(module)
			modules[obj.Name] = module
		end
	end
end

Engine.currentGame = nil

return Engine