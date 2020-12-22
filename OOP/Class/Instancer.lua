local Module = require"Toolbox.Import.Module"

local Derive = Module.Relative"Derive"

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
