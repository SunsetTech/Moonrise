local Execution = require"Moonrise.Adapt.Execution"

local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.Composable : Adapt.Transform.Base
---@operator call:Adapt.Transform.Composable
---@field private Parents table<string, any>
local Composable = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Composable", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

---@param Instance Adapt.Transform.Composable
---@param Pattern Adapt.Transform.Base
function Composable:Initialize(Instance, Pattern)
		Composable.Parents.Composable:Initialize(Instance, {Pattern = Pattern})
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function Composable:Raise(CurrentState, Argument)
	return Execution.Recurse(CurrentState, "Raise", "Pattern", self.Children.Pattern, Argument)
end

---@param CurrentState Adapt.Execution.State
---@param Argument any,
function Composable:Lower(CurrentState, Argument)
	return Execution.Recurse(CurrentState, "Lower", "Pattern", self.Children.Pattern, Argument)
end


return Composable
