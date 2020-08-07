local StoreProvider = require(script.StoreProvider)
local connect = require(script.connect)
local getStore = require(script.getStore)
local TempConfig = require(script.TempConfig)
local shallowEqual = require(script.shallowEqual)

return {
	StoreProvider = StoreProvider,
	connect = connect,
	UNSTABLE_getStore = getStore,
	UNSTABLE_connect2 = connect,
	shallowEqual = shallowEqual,
	TEMP_CONFIG = TempConfig,
}