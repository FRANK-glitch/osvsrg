local HttpService = game:GetService("HttpService")

local Http = {}

local function makeRequest(url, method, body, headers, onError)
    onError = onError or (function(msg)
        warn(msg)
    end)
	local params = {
		Headers=headers;
		Method=method;
        Url=url;
        Body=body or nil;
	}
	local res = nil
	local suc, err = pcall(function()
		res = HttpService:RequestAsync(params)
	end)
	if not suc then
        onError(err)
        return nil
    end
    local headers = res.Headers
    
    if string.find(headers["content-type"], "application/json") ~= nil then
        res.DecodedBody = Http:Deserialize(res.Body)
    end
	return res
end

function Http.withBaseEndpoint(base_)
    local base = base_ or ""
    local wbe = {}

    function wbe:Request(endpoint, method, body, headers, onError)
        return makeRequest(base..endpoint, method, body, headers, onError)
    end

    return wbe
end

function Http:Request(url, method, headers, onError)
    return makeRequest(url, method, headers, onError)
end

function Http:Serialize(tab)
    return HttpService:JSONEncode(tab)
end

function Http:Deserialize(str)
    return HttpService:JSONDecode(str)
end

return Http