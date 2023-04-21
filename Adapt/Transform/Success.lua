
local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.Success : Adapt.Transform.Base
---@operator call:Adapt.Transform.Success
---@field Value integer
local Success = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Success", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

---@param Value integer
function Success:Initialize(Instance, Value)
	Instance.Value = Value or true
end

function Success:Lower()
	return self.Value
end

function Success:Raise()
	return self.Value
end

return Success
