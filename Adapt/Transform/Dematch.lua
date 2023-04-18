

local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Dematch : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Dematch
Dematch = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Dematch", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Dematch:Initialize(Instance, With, Without)
	---@diagnostic disable-next-line:undefined-field
	Dematch.Parents.Compound:Initialize(
		Instance, {
			With = With;
			Without = Without
		}
	)
end

function Dematch:Recurse(MethodName, CurrentState, Argument)
	local Bookmark = CurrentState:Mark()
	local WithoutSuccess = Execution.Recurse(CurrentState, MethodName, "Without", self.Children.Without, Argument)
	if not WithoutSuccess then
		CurrentState:Rewind(Bookmark)
		local Success, Result = Execution.Recurse(CurrentState, MethodName, "With", self.Children.With, Argument)
		assert(Success ~= nil)
		return Success, Result
	end
	return false
end

---@param CurrentState Adapt.Execution.State
function Dematch:Raise(CurrentState, Argument) 
	return self:Recurse("Raise", CurrentState, Argument)
end

function Dematch:Lower(CurrentState, Argument)
	return self:Recurse("Lower", CurrentState, Argument)
end

function Dematch:Optimize()
		Dematch.Parents.Compound.Optimize(self)
	self.Recurse = Dematch.Recurse
end

return Dematch

