
local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.Nothing : Adapt.Transform.Base
---@operator call:Adapt.Transform.Nothing
local Nothing = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Nothing", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

function Nothing:Initialize(Instance)
end

function Nothing:Lower(CurrentState, Input)
	return true
end

function Nothing:Raise(CurrentState)
	return true
end

return Nothing
