-- Initial State
-- kisperal 
-- August 14, 2020

return {
    curScreen = "MainMenuScreen";
    curSelected = nil;
    settings = {
        ScrollSpeed = 20;
        NoteColor = Color3.fromHSV(0,0,0);
        Rate = 1;
        ShowGameplayUI = true;
        Keybinds = {
            [1] = Enum.KeyCode.Z;
            [2] = Enum.KeyCode.X;
            [3] = Enum.KeyCode.Comma;
            [4] = Enum.KeyCode.Period;
        };
        QuickExitKeybind = {
            [1] = Enum.KeyCode.Backspace;
        };
        HideGameplayUI = {
            [1] = Enum.KeyCode.M;
        };
        ScorePos = UDim2.new(0.92,0,0.035,0);
        AccuracyPos = UDim2.new(0.92,0,0.08,0);
        ComboPos = UDim2.new(0.5,0,0.2,0);
        JudgementPos = UDim2.new(0.5,0,0.25,0);
        RatingPos = UDim2.new(0.065,0,0.05,0);
        BackButtonPos = UDim2.new(0.923,0,0.955,0);
        FOV = 70;
        RateIncrement = 0.05;
        ShowMarvs = true;
        ShowPerfs = true;
        ShowGreats = true;
        ShowGoods = true;
        ShowBads = true;
        ShowMisses = true;
    };
    songStats = {
        score = 0;
        combo = 0;
        maxcombo = 0;
        marvs = 0;
        perfs = 0;
        greats = 0;
        goods = 0;
        bads = 0;
        miss = 0;
        accuracy = 0;
        total = 0;
    };
    curSelectedOptionTab = nil;
}