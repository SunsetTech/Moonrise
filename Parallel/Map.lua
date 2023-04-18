local OOP = require"Moonrise.OOP"

local Portal = require"Moonrise.Parallel.Portal"

---@class Parallel.Map
---@operator call:Parallel.Map
---@field Channel Parallel.Portal
local Map = OOP.Declarator.Shortcuts"Parallel.Map"

function Map:Initialize(Instance, Channel)
	rawset(
		Instance, 
		"Channel", Channel or Portal()
	)
end

function Map:__index(Key)
	return self.Channel:Get(Key)
end

function Map:__newindex(Key, Value)
	self.Channel:Set(Key, Value)
end

return Map
