local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local PlayerGui = game.LocalPlayer:WaitForChild("PlayerGui")

local Frameworks = PlayerGui.Frameworks
local Graph = require(Frameworks.Graph)

local Utils = script.Parent.Parent.Utils
local Metrics = require(Utils.Metrics)
local Math = require(Utils.Math)

local NpsGraph = Roact.Component:extend("NpsGraph")

function NpsGraph:init()
    
end

function NpsGraph:render()
    local graph = Graph.new("Bar")
    local curSelected = self.props.curSelected
    local rate = self.props.rate
	if curSelected ~= nil then
		local lowColor = Color3.fromRGB(237, 255, 148)
		local highColor = Color3.fromRGB(255, 0, 191)
		local maxColorNps = 32
		local n = curSelected:GetNpsGraph()
		local r = self.props.settings.Rate or 1
		graph.xfloor = 0
		graph.xceiling = math.floor(curSelected:GetLength()/1000)/r
		graph.xinterval = 30
		graph.yceiling = (Math.findMax(n)+5)*r
		graph.yfloor = 0
		graph.yinterval = math.floor(graph.yceiling/5)
		for i, v in pairs(n) do
			v = v*r
			graph:AddObject(i, v, lowColor:lerp(highColor, math.clamp(v/maxColorNps, 0, 1)))
		end
    end
end

return NpsGraph
