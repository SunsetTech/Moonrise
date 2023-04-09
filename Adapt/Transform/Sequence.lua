local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Execution = Module.Relative"Execution"

local Sequence = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Sequence", {
		Module.Sister"Compound"
	}
)

function Sequence:ExecuteChildren(ExecutionState, MethodName, Arguments)
	local Results = {}
	
	for Index, Child in pairs(self.Children) do
		local Argument = Arguments[Index]
		
		local Success, Result = Execution.Recurse(
			ExecutionState, 
			MethodName, Index, Child, 
			Argument
		)
		
		if Success then
			Results[Index] = Result
		else
			return false
		end
	end
	
	return true, Results
end

function Sequence:Raise(ExecutionState, Arguments)
	Arguments = Arguments or {}
	return self:ExecuteChildren(ExecutionState, "Raise", Arguments)
end

function Sequence:Lower(ExecutionState, Arguments)
	Arguments = Arguments or {}
	return self:ExecuteChildren(ExecutionState, "Lower", Arguments)
end

return Sequence
