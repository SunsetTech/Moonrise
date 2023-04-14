

local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Not : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Not
Not = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Not", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Not:Initialize(Instance, Pattern)
---@diagnostic disable-next-line:undefined-field
		Not.Parents.Compound:Initialize(Instance, {Pattern=Pattern})
end

---@param MethodName Adapt.MethodName
---@param CurrentState Adapt.Execution.State
---@param Argument any
---@return boolean
function Not:Execute(MethodName, CurrentState, Argument)
	local Bookmark = CurrentState:Mark()
		local Success = Execution.Recurse(CurrentState, MethodName, "Pattern", self.Children.Pattern, Argument)
	CurrentState:Rewind(Bookmark)
	return Success
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function Not:Raise(CurrentState, Argument) --Root
	return not self:Execute("Raise", CurrentState, Argument)
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function Not:Lower(CurrentState, Argument)
	return not self:Execute("Lower", CurrentState, Argument)
end

return Not

