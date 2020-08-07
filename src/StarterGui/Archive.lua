--[[
    ARCHIVED CODE:

    local function ColorOption(name, bound)
	local boundFire = "Update"..bound
	self_[bound], self_[boundFire] = Roact.createBinding(Settings.Options[bound])
	self_.sliderRef = Roact.createRef()
	self_.sliderRef1 = Roact.createRef()
	self_.mouseDown = false
	self_.mouseDown1 = false
	self_.hueB, self_.hueC = Roact.createBinding(Settings.Options[bound])
	optionNumber = optionNumber + 1

	local o = Settings.Options[bound]
	local v = o.Value
	local s = o.Saturation
	local h = o.Hue
	local vcurScale = 0

	if s == 1 then
		vcurScale = 1-(v/2)
	else
		vcurScale = s/2
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(0.975,0,0.075,0);
		Position = UDim2.new(0, 0, (optionNumber-1) / (maxOptionNumber * 2) + ((optionNumber - 1) / 100), 0);
		BackgroundColor3 = Color3.fromRGB(27, 27, 27);
		BorderSizePixel = 0;
	}, {
		Name = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1;
			Font = Enum.Font.GothamBlack;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			Text = name;
			TextScaled = true,
			TextWrapped = true,
			Position = UDim2.new(0.025,0,0.5,0);
			Size = UDim2.new(0.2,0,0.25,0);
		});
		-- COLOR RAINBOW HAS ISSUES
		ColorRainbow = Roact.createElement("Frame", {
			Size = UDim2.new(0.4,0,0.5,0);
			AnchorPoint = Vector2.new(0,0.5);
			Position = UDim2.new(0.3,0,0.5,0);
			BorderSizePixel = 0;
			[Roact.Ref] = self_.sliderRef;
			[Roact.Event.MouseMoved] = function(rbx, x, y)
				local slider = self_.sliderRef:getValue()
				local sx = x-slider.AbsolutePosition.X
				if self_.mouseDown then
					local cursor = slider.Cursor
					if cursor then
						local hue = sx/slider.AbsoluteSize.X
						local originalColor = Settings.Options[bound]
						local newColor = Color:changeHSV(originalColor, {
							Hue = 1-hue
						})
						Settings:ChangeOption(bound, newColor)
						self_.hueC(Settings.Options[bound])
						cursor.Position = UDim2.new(hue,0,0,0)
					end
				end
			end
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = getRainbow()
			});
			Cursor = Roact.createElement("ImageButton", {
				BackgroundColor3 = Color3.new(0,0,0);
				BorderSizePixel = 0;
				Size = UDim2.new(0,5,1,0);
				Position = UDim2.new(1-Settings.Options[bound].Hue,0,0,0);
				AnchorPoint = Vector2.new(0.5,0);
				ImageTransparency = 1;
				BackgroundTransparency = 0;
				[Roact.Event.MouseButton1Down] = function(rbx)
					self_.mouseDown = true
				end;
				[Roact.Event.MouseButton1Up] = function(rbx)
					self_.mouseDown = false
				end;
			})
		});
		ColorValue = Roact.createElement("Frame", {
			Size = UDim2.new(0.2,0,0.5,0);
			AnchorPoint = Vector2.new(0,0.5);
			Position = UDim2.new(0.72,0,0.5,0);
			BorderSizePixel = 0;
			[Roact.Ref] = self_.sliderRef1;
			[Roact.Event.MouseMoved] = function(rbx, x, y)
				local slider = self_.sliderRef1:getValue()
				local sx = x-slider.AbsolutePosition.X
				local threshold = 0.5
				if self_.mouseDown1 then
					local cursor = slider.Cursor
					if cursor then
						local value = sx/slider.AbsoluteSize.X
						local originalColor = Settings.Options[bound]
						local newColor
						if value > 0.5 then
							newColor = Color:changeHSV(originalColor, {
								Saturation = 1;
								Value = 1-((value-0.5)*2);
							})
						elseif value < 0.5 then
							newColor = Color:changeHSV(originalColor, {
								Saturation = value*2;
								Value = 1;
							})
						end
						Logger:Log(string.format("New note color: H: %0.2f S: %0.2f V: %0.2f ", newColor.Hue, newColor.Saturation, newColor.Value))
						Settings:ChangeOption(bound, newColor)
						cursor.Position = UDim2.new(value,0,0,0)
					end
				end
			end
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = self_.hueB:map(function(clr)
					local tab = {}
					for i, v in pairs(clr) do
						tab[i] = v
					end
					local brightSpec = Color:changeHSV(tab, {
						Saturation = 1;
						Value = 1;
					})
					return getHue(Color:convertHSV(brightSpec))
				end)
			});
			Cursor = Roact.createElement("ImageButton", {
				BackgroundColor3 = Color3.new(0,0,0);
				Size = UDim2.new(0,5,1,0);
				BorderSizePixel = 0;
				Position = UDim2.new(vcurScale,0,0,0);
				AnchorPoint = Vector2.new(0.5,0);
				ImageTransparency = 1;
				BackgroundTransparency = 0;
				[Roact.Event.MouseButton1Down] = function(rbx)
					self_.mouseDown1 = true
				end;
				[Roact.Event.MouseButton1Up] = function(rbx)
					self_.mouseDown1 = false
				end;
			})
		})
	})
end
]]--