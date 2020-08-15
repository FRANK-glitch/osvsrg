-- Screen Class
-- Username
-- August 13, 2020



local ScreenClass = {}
ScreenClass.__index = ScreenClass


function ScreenClass.new()

	local self = setmetatable({

	}, ScreenClass)

	return self

end

ScreenClass.RoactView = {}


return ScreenClass