local Module = require"Moonrise.Import.Module"
local Tools = {
	Error = require"Moonrise.Tools.Error"
}

local Create = require"Moonrise.OOP.Create"
local Derive = require"Moonrise.OOP.Derive"
local Root = require"Moonrise.OOP.Class.Root"
local Linker = require"Moonrise.OOP.Class.Linker"
local Factory = require"Moonrise.OOP.Class.Factory"
local Constructor = require"Moonrise.OOP.Class.Constructor"

return Factory(
	Derive(
		"OOP.Declarator.Definition", {Factory, Constructor},
		{
			__instantiate = function(self, Name, Inherits, Static, Dynamic, Link)
				Inherits = Inherits or {Root}
				Tools.Error.CallerAssert(type(Inherits) == "table" and #Inherits > 0, "Must have a base class")
				
				local Obj = Create(
					self,
					Derive(
						Name, Inherits,
						Static, Dynamic, Link or Linker
					)
				)
				return Obj
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
