local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)


local Dot = {}

function Dot:new()
	local self = {}
	
	self.dotcolor = Color3.new()
	
	self.xinterval = 1
	self.yinterval = 1
	
	self.linex = false
	self.liney = true
	
	self.xfloor = 0
	self.xceiling = 11
	self.yfloor = 0
	self.yceiling = 11
	
	self.objects = {}
	
	local function reverseLerp(a,b,c)
		b = b - a
		c = c - a
		return c/b
	end
	
	local function lerp(a,b,t)
		if t == 0 then
			return a
		end
		return (a+b)/(1/t)
	end
	
	local function getSPosition(x, y)
		return {
			X=reverseLerp(self.xfloor,self.xceiling,x);
			Y=reverseLerp(self.yfloor,self.yceiling,y);
		}
	end
	
	local function genObj(x, y, color)
		self.objects[#self.objects+1] = {
			X=x;
			Y=y;
			Color=color;
		}
	end
	
	local function Lines(props)
		local m = {}
		local my = {}
		
		if self.linex then
			for i = self.xfloor, self.xceiling, self.xinterval do
				local pos = reverseLerp(self.xfloor,self.xceiling,i)
				m[#m+1] = Roact.createElement("Frame", {
					BackgroundTransparency=0.3;
					BorderSizePixel=0;
					AnchorPoint=Vector2.new(0,0.5);
					Size=UDim2.new(0,1,1,0);
					Position=UDim2.new(pos,0,0,0);
					BackgroundColor3=Color3.new(0.19,0.19,0.19)
				})
			end
		end
		if self.liney then
			for i = self.yfloor, self.yceiling, self.yinterval do
				local pos = reverseLerp(self.yfloor,self.yceiling,i)
				my[#my+1] = Roact.createElement("Frame", {
					BackgroundTransparency=0.3;
					BorderSizePixel=0;
					AnchorPoint=Vector2.new(0,0.5);
					Size=UDim2.new(1,0,0,1);
					Position=UDim2.new(0,0,1-pos,0);
					BackgroundColor3=Color3.new(0.19,0.19,0.19)
				})
			end
		end
		
		return Roact.createElement("Frame",{
			Size=UDim2.new(0.8,0,0.8,0);
			AnchorPoint=Vector2.new(0.5,0.5);
			Position=UDim2.new(0.5,0,0.5,0);
			BackgroundTransparency=1;
		}, Roact.createFragment({
			X=Roact.createFragment(m);
			Y=Roact.createFragment(my);
		}))
	end
	
	local function Markers(props)
		local m = {}
		local my = {}
		for i = self.xfloor, self.xceiling, self.xinterval do
			local pos = reverseLerp(self.xfloor,self.xceiling,i)
			m[#m+1] = Roact.createElement("TextLabel", {
				BackgroundTransparency=1;
				AnchorPoint=Vector2.new(0.5,0.5);
				TextSize=9;
				Size=UDim2.new(0,9*tostring(i):len(),0,9);
				Position=UDim2.new(pos,0,0.75,0);
				Text=tostring(i);
				TextXAlignment=Enum.TextXAlignment.Center;
				TextColor3=Color3.new(0.25,0.25,0.25)
			})
		end
		for i = self.yfloor, self.yceiling, self.yinterval do
			local pos = reverseLerp(self.yfloor,self.yceiling,i)
			my[#my+1] = Roact.createElement("TextLabel", {
				BackgroundTransparency=1;
				AnchorPoint=Vector2.new(0.5,0.5);
				TextSize=9;
				Size=UDim2.new(0,9*tostring(i):len(),0,9);
				Position=UDim2.new(0.15,0,1-pos,0);
				Text=tostring(i);
				TextXAlignment=Enum.TextXAlignment.Center;
				TextColor3=Color3.new(0.29,0.29,0.29)
			})
		end
		return Roact.createFragment({
			X=Roact.createElement("Frame",{
				AnchorPoint=Vector2.new(0.5,1);
				Position=UDim2.new(0.5,0,1,0);
				Size=UDim2.new(0.8,0,0.2,0);
				BackgroundTransparency=1;
			}, m);
			Y=Roact.createElement("Frame",{
				AnchorPoint=Vector2.new(0,0.5);
				Position=UDim2.new(0,0,0.5,0);
				Size=UDim2.new(0.2,0,0.8,0);
				BackgroundTransparency=1;
			}, my);
		})
	end
	
	local function Points(props)
		local roactob = {}
		for i, point in pairs(self.objects) do
			local pos = getSPosition(point.X, point.Y)
			roactob[#roactob+1] = Roact.createElement("Frame", {
				Size=UDim2.new(0,4,0,4);
				Position=UDim2.new(pos.X,0,pos.Y,0);
				BackgroundColor3=point.Color or props.DotColor or Color3.new(1,1,1);
				BorderSizePixel=0;
				AnchorPoint=Vector2.new(0.5,0.5);
			})
		end
		return Roact.createElement("Frame",{
			Size=UDim2.new(0.8,0,0.8,0);
			AnchorPoint=Vector2.new(0.5,0.5);
			Position=UDim2.new(0.5,0,0.5,0);
			BackgroundTransparency=1;
		}, roactob)
	end
	
	function self:AddObject(x, y, color)
		genObj(x, y, color)
	end
	
	function self.component(props)
		return Roact.createElement("Frame", {
			AnchorPoint=props.Anchor or Vector2.new(0,0);
			Position=props.Position or UDim2.new(0,0,0,0);
			Size=props.Size or UDim2.new(0.2,0,0.4,0);
			BackgroundColor3=props.BGColor or Color3.new(0.1,0.1,0.1);
			ClipsDescendants=true
		}, {
			Objects=Roact.createElement(Points, props);
			Markers=Roact.createElement(Markers);
			Lines=Roact.createElement(Lines)
		})
	end
	
	return self
end

return Dot