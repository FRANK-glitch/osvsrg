-- Menu Option
-- kisperal 
-- August 14, 2020

local Roact: Roact
local RoactAnimate

local MenuOption = {}

function MenuOption:init()
    Roact = self.Shared.Roact
    RoactAnimate = self.Shared.RoactAnimate
    self._position = RoactAnimate.Value.new(self.props.Position or UDim2.new(0.025, 0, 0.38, 0))
end

function MenuOption:render()
    return Roact.createElement(RoactAnimate.ImageButton, {
        Size = self.props.Size,
        Position = self._position,
        ZIndex = self.props.ZIndex or 2,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        Image = "rbxassetid://2790382281",
        SliceCenter = Rect.new(4, 4, 252, 252),
        SliceScale = 1,
        ImageColor3 = Color3.fromRGB(27, 27, 27),
        [Roact.Event.MouseButton1Click] = self.props.OnClick,
        [Roact.Event.MouseEnter] = function()
            RoactAnimate(self._position, TweenInfo.new(0.125), self._position.Value - UDim2.new(0, 0, 0, 3)):Start()
        end;
        [Roact.Event.MouseLeave] = function()
            RoactAnimate(self._position, TweenInfo.new(0.125), self._position.Value):Start()
        end;
    }, {
        Label = Roact.createElement("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0.85, 0, 0.6, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Text = self.props.Text,
            Font = Enum.Font.GothamBlack,
            TextScaled = true,
            TextWrapped = true,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
    })
end

return MenuOption