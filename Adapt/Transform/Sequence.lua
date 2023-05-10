local OOP = require"Moonrise.OOP"
local Pretty = require"Moonrise.Tools.Pretty"
local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Sequence : Adapt.Transform.Compound
local Sequence = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Sequence", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Sequence:GetType()
	local TypeInfo = {
		Type = "table";
		Elements = {};
	}
	for _, Child in pairs(self.Children) do
		table.insert(TypeInfo.Elements, Child:GetType())
	end

	return TypeInfo
end

function Sequence:ExecuteChildren(ExecutionState, MethodName, Arguments)
	--assert(type(Arguments) == "table")
		local Results = {}
		for Index = 1, #self.Children do
			local Child = self.Children[Index]
			local Argument = Arguments[Index]
			local Success, Result = Execution.Recurse(
				ExecutionState, 
				MethodName, Child, 
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

function Sequence:Optimize()
	Sequence.Parents.Compound.Optimize(self)
	self.ExecuteChildren = Sequence.ExecuteChildren
end

function Sequence:__tostring()
	local Parts = {}
	for _, Child in pairs(self.Children) do
		table.insert(Parts, tostring(Child))
	end
	return "(".. table.concat(Parts, " * ") ..")"
end

return Sequence
