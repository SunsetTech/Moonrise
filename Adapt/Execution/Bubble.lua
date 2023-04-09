local OOP = require"Moonrise.OOP"

local Bubble = OOP.Declarator.Shortcuts"Adapt.Execution.Bubble"

function Bubble:Initialize(Instance, Values)
	Instance.Values = Values
end

function Bubble:__call()
	return table.unpack(self.Values)
end

function Bubble.Form(First, ...)
	return (select("#",...) >= 1 and Bubble(First, ...) or First)
end

function Bubble.Is(Value)
	return OOP.Reflection.Type.Name(Value) == "Adapt.Execution.Bubble"
end

function Bubble.Pop(Value)
	if Bubble.Is(Value) then
		return Value()
	else
		return Value
	end
end

return Bubble
