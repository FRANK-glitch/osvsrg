-- Engine
-- kisperal 
-- August 15, 2020



local Engine = {}
Engine.__index = Engine


function Engine.new()

	local self = setmetatable({
		Note = require(script.Note);
		Hold = require(script.Hold);
		Game = require(script.Game);
	}, Engine)

	return self

end

function Engine:StartGame()
	
end

function Engine:EndGame()
	if self.currentGame ~= nil then
		self.currentGame:Quit()
	end
	self.currentGame = nil
end



Engine.currentGame = nil

return Engine