-- Metrics
-- kisperal 
-- August 15, 2020



local Metrics = {}

function Metrics:CalculateRateMult(rate)
	local ratemult = 1
	if rate then
		if rate >= 1 then
			ratemult = 1 + (rate-1) * 0.6
		else
			ratemult = 1 + (rate-1) * 2
		end
	end
	return ratemult
end

function Metrics:CalculateSR(rate,difficulty,acc)
	local ratemult = Metrics:CalculateRateMult(rate)
	return ratemult * ((acc/97)^4) * difficulty
end

function Metrics:GetTierData(rating)
	local tiers = Metrics.Constants.Tiers
	for i = 1, #tiers do
		local data = tiers[i]
		if rating >= data.Rating then
			return data
		end
	end
end

function Metrics:GetGradeData(acc)
	local stats = Metrics.Constants.Stats
	for i = 1, #stats do
		local data = stats[i]
		if acc >= data.Accuracy or i == #stats then
			return data
		end
	end
end

function Metrics:GetJudgementColor(judgeNum)
	return Metrics.Constants.Judgements[judgeNum] or Metrics.Constants.Judgements[#Metrics.Constants.Judgements]
end

local function genTierData(rating, title, color)
	return {
		Rating=rating;
		Title=title;
		Color=color;
	}
end

local function genStatData(Acc, Title, Color)
	return {
		Accuracy=Acc;
		Title=Title;
		Color=Color;
	}
end

Metrics.Constants = {
	Tiers = {
		[13] = genTierData(0,"Tier 0 - Beginner",Color3.new(0.5,0.5,0.5));
		[12] = genTierData(6,"Tier 1 - Novice",Color3.new(0.3,0.5,1));
		[11] = genTierData(10,"Tier 2 - Amateur",Color3.new(0.3,1,1));
		[10] = genTierData(14,"Tier 3 - Intermediate",Color3.new(0.3,1,0.6));
		[9] = genTierData(18,"Tier 4 - Advanced",Color3.new(0.3,1,0.3));
		[8] = genTierData(22,"Tier 5 - Expert",Color3.new(0.7,1,0.3));
		[7] = genTierData(26,"Tier 6 - Professional",Color3.new(1,1,0.3));
		[6] = genTierData(30,"Tier 7 - Master",Color3.new(1,0.5,0.3));
		[5] = genTierData(34,"Tier 8 - Guru",Color3.new(1,0.3,0.3));
		[4] = genTierData(38,"Tier 9 - Divine",Color3.new(1,0.3,0.7));
		[3] = genTierData(42,"Tier 10 - Legendary",Color3.new(1,0.6,1));
		[2] = genTierData(46,"Tier 11 - God",Color3.new(1,1,1));
		[1] = genTierData(50,"Tier 12 - Extraterrestrial",Color3.new(1,1,1));
	};
	Stats = {
		[1] = genStatData(100, "SS", Color3.new(1,1,1));
		[2] = genStatData(95, "S", Color3.fromRGB(241, 255, 92));
		[3] = genStatData(90, "A", Color3.fromRGB(97, 252, 66));
		[4] = genStatData(80, "B", Color3.fromRGB(30, 136, 250));
		[5] = genStatData(70, "C", Color3.fromRGB(140, 30, 250));
		[6] = genStatData(60, "D", Color3.fromRGB(138, 0, 76));
		[7] = genStatData(50, "F", Color3.fromRGB(196, 0, 3));
		[8] = genStatData(40, "F-", Color3.fromRGB(115, 115, 115));
	};
	Judgements = {
		[1] = Color3.fromRGB(255, 254, 212);
		[2] = Color3.fromRGB(252, 244, 3);
		[3] = Color3.fromRGB(106, 212, 0);
		[4] = Color3.fromRGB(0, 102, 130);
		[5] = Color3.fromRGB(112, 0, 161);
		[6] = Color3.fromRGB(189, 2, 5);
	}
}

return Metrics
