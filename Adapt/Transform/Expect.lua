local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Expect : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Expect
Expect = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Expect", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Expect:Initialize(Instance, Pattern)
---@diagnostic disable-next-line:undefined-field
		Expect.Parents.Compound:Initialize(Instance, {Pattern=Pattern})
end

---@param CurrentState Adapt.Execution.State
function Expect:FormatError(CurrentState)
	return ("Failed at %s(%s)"):format(CurrentState:GetPath(), self.Children.Pattern)
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function Expect:Raise(CurrentState, Argument) --Root
	local Success, Result = Execution.Recurse(CurrentState, "Raise", "1", self.Children.Pattern, Argument)
	assert(Success, self:FormatError(CurrentState))
	return Success, Result
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function Expect:Lower(CurrentState, Argument)
	local Success, Result = Execution.Recurse(CurrentState, "Lower", "1", self.Children.Pattern, Argument)
	assert(Success, self:FormatError(CurrentState))
	return Success, Result
end

return Expect

