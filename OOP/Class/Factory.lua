local Module = require"Moonrise.Import.Module"

local Create = Module.Relative"Create"
local Derive = Module.Relative"Derive"
local Instancer = Module.Sister"Instancer";

return Create(
	Instancer,
	Derive(
		"OOP.Class.Factory", {
			Module.Sister"Constructor";
			Instancer;
		},
		{
			__instantiate = function(self, Definition)
				local Instance, ID = Create(self, Definition)
				return Instance, ID
			end;
		}
	)
)
