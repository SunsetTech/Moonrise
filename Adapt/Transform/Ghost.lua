
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Ghost : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Ghost
Ghost = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Ghost", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Ghost:Initialize(Instance, Pattern)
---@diagnostic disable-next-line:undefined-field
		Ghost.Parents.Compound:Initialize(Instance, {Pattern=Pattern})
end

---@param MethodName Adapt.MethodName
---@param CurrentState Adapt.Execution.State
---@param Argument any
---@return boolean, any
function Ghost:Execute(MethodName, CurrentState, Argument)
	local Bookmark = CurrentState:Mark()
		local Success, Result = Execution.Recurse(CurrentState, MethodName, self.Children.Pattern, Argument)
	CurrentState:Rewind(Bookmark)
	return Success, Result --This is supposed to not consume input (or return a value) but if we dont return what made us match we wont match on Lower. i suspect there is still a subtle bug present we may need a slightly more sophisticated solution
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function Ghost:Raise(CurrentState, Argument) --Root
	return self:Execute("Raise", CurrentState, Argument)
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function Ghost:Lower(CurrentState, Argument)
	return self:Execute("Lower", CurrentState, Argument)
end

function Ghost:__tostring()
	return "#".. tostring(self.Children.Pattern)
end

return Ghost

