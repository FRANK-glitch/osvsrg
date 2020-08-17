-- Engine
-- kisperal 
-- August 15, 2020



local Engine = {}

local Game = require(script.Game)

function Engine:NewGame(settings)
	local _game = Game:new(settings)
	self.currentGame = _game
	return self.currentGame
end

function Engine:Init()
	for _,obj in ipairs(script:GetChildren()) do
		if (obj:IsA("ModuleScript")) then
			self:WrapModule(require(obj))
		end
	end
end

Engine.currentGame = nil

return Engine