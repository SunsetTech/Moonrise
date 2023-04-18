local Module = require"Moonrise.Import.Module"

local Derive = Module.Relative"Derive"

--Defines a metatable that links calls to __new
return Derive(
	"OOP.Class.Instancer", {
		Module.Sister"RTTI"
	},
	{
		__call = function(self, ...)
			local Instance = self:__new(...)
			return Instance
		end;
	}
)
