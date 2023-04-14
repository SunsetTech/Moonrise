
local OOP = require"Moonrise.OOP"

---@class Bubble
---@field public Values table
---@operator call(): Bubble
local Bubble = OOP.Declarator.Shortcuts("Adapt.Execution.Bubble")

---@param Instance table
---@param Values table
function Bubble:Initialize(Instance, Values)
    Instance.Values = Values
end

function Bubble:__call()
    return table.unpack(self.Values)
end

function Bubble:__len()
	print"???"
	return #self.Values
end

---@param First any
---@param ... any
---@return Bubble|any
function Bubble.Form(First, ...)
    return (select("#", ...) >= 1 and Bubble(First, ...) or First)
end

---@param Value any
---@return boolean
function Bubble.Is(Value)
    return OOP.Reflection.Type.Name(Value) == "Adapt.Execution.Bubble"
end

---@param Value any
---@return any
function Bubble.Pop(Value)
    if Bubble.Is(Value) then
        return Value()
    else
        return Value
    end
end

return Bubble

