---@alias Adapt.Transform.Filter.Recurse fun(Argument: any): boolean, any
---@alias Adapt.Transform.Filter.Method fun(Recurse: Adapt.Transform.Filter.Recurse, Argument: any, CurrentState: Adapt.Execution.State): boolean, any

---@class Adapt.Transform.Filter.Table
---@field Raise Adapt.Transform.Filter.Method
---@field Lower Adapt.Transform.Filter.Method

local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Filter : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Filter
---@field Filters Adapt.Transform.Filter.Table
Filter = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Filter", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

---@param Pattern Adapt.Transform.Base
---@param Raise Adapt.Transform.Filter.Method
---@param Lower Adapt.Transform.Filter.Method
function Filter:Initialize(Instance, Pattern, Raise, Lower)
---@diagnostic disable-next-line:undefined-field
		Filter.Parents.Compound:Initialize(Instance, {Pattern = Pattern})
	Instance.Filters = {
		Raise = Raise;
		Lower = Lower;
	}
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function Filter:Raise(CurrentState, Argument) --Root
	return self.Filters.Raise(
		function(_Argument)
			return Execution.Recurse(CurrentState, "Raise", "Pattern", self.Children.Pattern, _Argument)
		end, Argument, CurrentState
	)
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function Filter:Lower(CurrentState, Argument)
	return self.Filters.Lower(
		function(_Argument)
			return Execution.Recurse(CurrentState, "Lower", "Pattern", self.Children.Pattern, _Argument)
		end, Argument, CurrentState
	)
end

return Filter

