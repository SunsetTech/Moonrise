unpack = unpack or table.unpack
require"Moonrise.Import.Install".All()

local OOP = require"Moonrise.OOP"

local Bubble = {}

Bubble.Form = OOP.Class.Factory(
	OOP.Derive(
		"Bubble", {}, {
			__new = function(self, ...)
				local Instance = {...}
				return OOP.Create(self, Instance)
			end;
			__call = function(self)
				return table.unpack(self)
			end;
		}
	)
)

function Bubble.Pop(What)
	return What()
end

function Bubble.Is(What)
	return OOP.Reflection.Type.Name(What) == "Bubble"
end

return Bubble
