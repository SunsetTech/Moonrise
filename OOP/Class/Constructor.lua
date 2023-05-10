local Module = require"Moonrise.Import.Module"
local Derive = require"Moonrise.OOP.Derive"
local Create = require"Moonrise.OOP.Create"

--- @vararg any
--- @return table, string
local function __instantiate(self, ...) --Unused?
	local Instance, ID = Create(self)
	return Instance, ID
end

--- @param Instance table
--- @vararg any
local function __initialize(self, Instance, ...)
end

--- @vararg any
--- @return table
local function __new(self, ...)
	--local Instance = self:__instantiate(...)
	--self.__initialize(self, Instance, ...) --not JIT optimizable?
	--return Instance
	--local New = self:__instantiate(...)
	--return New
	return self:__instantiate(...)
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

