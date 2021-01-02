local Module = require"Moonrise.Import.Module"
local Tools = require"Moonrise.Tools"

local Create = Module.Relative"Create"
local Derive = Module.Relative"Derive"
local Root = Module.Relative"Class.Root"
local Linker = Module.Relative"Class.Linker"

return Module.Relative"Class.Factory"(
	Derive(
		"OOP.Declarator.Definition", {
			Module.Relative"Class.Factory";
			Module.Relative"Class.Constructor";
		},
		{
			__instantiate = function(self, Name, Inherits, Static, Dynamic, Link)
				Inherits = Inherits or {Root}
				Tools.Error.CallerAssert(type(Inherits) == "table" and #Inherits > 0, "Must have a base class")
				
				return Create(
					self,
					Derive(
						Name, Inherits,
						Static, Dynamic, Link or Linker
					)
				)
			end;
			
			__index = function()
				Tools.Error.CallerError"Definition member not found"
			end;
			
			__newindex = function(self, Key, Value)
				Tools.Error.CallerAssert(type(Key) == "string" and Key:sub(1,2) == "__", "Definition member must start with __")
				rawset(self, Key, Value)
			end;
		}
	)
)
