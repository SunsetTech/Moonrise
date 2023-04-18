local Module = require"Moonrise.Import.Module"
local Derive = require"Moonrise.OOP.Derive"
local Create = require"Moonrise.OOP.Create"

--- @vararg any
--- @return table, string
local function __instantiate(self, ...)
	return Create(self)
end

--- @param Instance table
--- @vararg any
local function __initialize(self, Instance, ...)
end

--- @vararg any
--- @return table
local function __new(self, ...)
	local Instance = self:__instantiate(...)
	self:__initialize(Instance, ...) --not JIT optimizable?
	return Instance
end

return Derive(
	"OOP.Class.Constructor", {
		Module.Sister"RTTI"
	},
	{
		__instantiate = __instantiate,
		__initialize = __initialize,
		__new = __new
	}
)

