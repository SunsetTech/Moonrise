local Error = require"Moonrise.Tools.Error"
local Module = require"Moonrise.Import.Module"

local Create = Module.Relative"Create"
local Derive = Module.Relative"Derive"

return Module.Sister"Factory"(
	Derive(
		"OOP.Class.Unimplemented", {
			Module.Sister"Constructor"
		}, {
			__call = function(Instance)
				Error.Caller.Throw(Instance.Name ..".".. Instance.Key .." not implemented.")
			end;
			
			__instantiate = function(self)
				return Create(self)
			end;
			
			__initialize = function(self, Instance, Name, Key)
				Instance.Name = Name
				Instance.Key = Key
			end;
		}
	)
)
