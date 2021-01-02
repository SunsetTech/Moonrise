local Module = require"Moonrise.Import.Module"
local Tools = require"Moonrise.Tools"
local Derive = Module.Relative"Derive"
local Create = Module.Relative"Create"

return Derive(
	"OOP.Class.Constructor", {
		Module.Sister"RTTI"
	},
	{
		__instantiate = function(self)
			return Create(self)
		end;
		
		__initialize = function(self)
		end;
		
		__new = function(self, ...)
			local Instance = self:__instantiate(...)
				self.__initialize(self,Instance, ...)
			return Instance
		end;
	}
)
