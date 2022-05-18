local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Bubble = OOP.Declarator.Shortcuts"Adapt.Bubble"

function Bubble:Initialize(Instance, ...)
	Instance.Values = {...}
end

function Bubble:__call()
	return table.unpack(self.Values)
end

function Bubble.Form(First, Second, ...)
	return First, (select("#",...) >= 1 and Bubble(Second, ...) or Second)
end

function Bubble.Pop(Value)
	if OOP.Reflection.Type.Name(Value) == "Adapt.Bubble" then
		return Value()
	else
		return Value
	end
end

return Bubble
