
--- @treturn table
local Module = require"Moonrise.Import.Module"
local Tools = require"Moonrise.Tools"
local Derive = Module.Relative"Derive"
local Create = Module.Relative"Create"

--- @vararg any
--- @return table
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
	self.__initialize(self, Instance, ...)
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

