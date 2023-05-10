local Module = require"Moonrise.Import.Module"

local Create = Module.Relative"Create"
local Derive = Module.Relative"Derive"

return Module.Sister"Factory"(
	Derive(
		"OOP.Class.Linker", {
			Module.Sister"Constructor"
		},
		{
			__index = function(self, Name)
				return self.Generators[Name]
			end;
			
			__newindex = function(self, Name, Generator)
				self.Generators[Name] = Generator
			end;
			
			__call = function(self, Target, Destination)
				Destination = Destination or Target
				for Name, Generator in pairs(self.Generators) do
					Destination[Name] = Generator(self.Target, Target)
				end
				return Destination
			end;
			
			__instantiate = function(self, Target, Initializer)
				local Instance = Create(self)
				rawset(Instance, "Target", Target)
				rawset(Instance, "Generators", Initializer or {})
				return Instance
			end;
			
			--[[__instantiate = function(self, Instance, Target, Initializer)
				print(Instance, Target, Initializer)
				return Create(self)

			end;
			
			__initialize = function(self, Instance, Target, Initializer)
				rawset(Instance, "Target", Target)
				rawset(Instance, "Generators", Initializer or {})
			end;]]
		}
	)
)
