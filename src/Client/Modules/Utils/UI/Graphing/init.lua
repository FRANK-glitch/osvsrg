return {
	new = function(type)
		return require(script:FindFirstChild(type)):new()		
	end
}
