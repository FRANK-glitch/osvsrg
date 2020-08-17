-- Audio Controller
-- kisperal 
-- August 17, 2020



local AudioController = {}


function AudioController:Start()
	
end


function AudioController:Init()
	self.channels = {}
end

function AudioController:NewChannel()
    self.channels[#self.channels] = Instance.new("Sound")
end


return AudioController