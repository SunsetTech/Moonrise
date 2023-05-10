

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

---comment
---@param MethodName Adapt.MethodName
---@param CurrentState Adapt.Execution.State
---@param Argument any
---@return boolean, any
function Dematch:Recurse(MethodName, CurrentState, Argument)
	local Start = CurrentState:Mark()
	local Success, Result = Execution.Recurse(CurrentState, MethodName, self.Children.With, Argument)
	local After = CurrentState:Mark()
	if Success then
		CurrentState:Rewind(Start)
		local WithoutSuccess = Execution.Recurse(CurrentState, "Raise", self.Children.Without, Argument)
		if not WithoutSuccess then
			CurrentState:Rewind(After)
			return Success, Result
		end
	end
	return false
end

--[[function Dematch:Recurse(MethodName, CurrentState, Argument)
	local Bookmark = CurrentState:Mark()
	local WithoutSuccess = Execution.Recurse(CurrentState, MethodName, self.Children.Without, Argument)
	if not WithoutSuccess then
		CurrentState:Rewind(Bookmark)
		local Success, Result = Execution.Recurse(CurrentState, MethodName, self.Children.With, Argument)
		return Success, Result
	end
	return false
end]]

---@param CurrentState Adapt.Execution.State
function Dematch:Raise(CurrentState, Argument) 
	return self:Recurse("Raise", CurrentState, Argument)
end

--TODO there's a subtle bug here that fixing might be complicated. I'm beginning to consider disabling passing arguments to Raise. Maybe that can be better implmented as state anyway. except state isn't composable. hmm
function Dematch:Lower(CurrentState, Argument)
	return self:Recurse("Lower", CurrentState, Argument)
end

function Dematch:Optimize()
		Dematch.Parents.Compound.Optimize(self)
	self.Recurse = Dematch.Recurse
end

return Dematch

