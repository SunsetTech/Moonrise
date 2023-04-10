local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

local Repeated = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Repeated", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

function Repeated:Initialize(Instance, Amount, Pattern)
	Instance.Amount = Amount -- >0 = atmost <0 = atleast 0 = greedy
	Instance.Pattern = Pattern
end

function Repeated:Lower(ExecutionState, Argument)
	if self.Amount == 0 then
		if Execution.Bubble.Is(Argument) then --bubble->bubble
			local Arguments = Argument.Values
			local Results = {}
			
			local Success
			for Index, _Argument in pairs(Arguments) do
				local Result
				Success, Result = Execution.Recurse(
					ExecutionState,
					"Lower", Index, self.Pattern, _Argument
				)
				if Success then
					table.insert(Results, Result)
				else
					error"oh no"
				end
			end
			Results = Execution.Bubble(Results)
			return true, Results
		else
			error"Must be a bubble"
		end
	elseif self.Amount > 0 then
		if Execution.Bubble.Is(Argument) then
			local Arguments = Argument.Values
			assert(#Arguments == self.Amount)
			local Results = {}
			
			local Success
			for Index, _Argument in pairs(Arguments) do
				local Result
				Success, Result = Execution.Recurse(
					ExecutionState,
					"Lower", Index, self.Pattern, _Argument
				)
				if Success then
					table.insert(Results, Result)
				else
					error"oh no"
				end
			end
			Results = Execution.Bubble(Results)
			return true, Results
		else
			error"Must be a bubble"
		end
	else --TODO negative case
	end
end

function Repeated:Raise(ExecutionState, Argument)
	if self.Amount == 0 then --Greedy
		if Execution.Bubble.Is(Argument) then --TODO bubble->bubble args version
		else -- single->bubble
			local Success, Bookmark
			local Results = {}
			repeat
				Bookmark = ExecutionState:Mark()
				local Result
				Success, Result = Execution.Recurse(
					ExecutionState,
					"Raise", "SubPattern", self.Pattern, Argument
				)
				if Success then
					table.insert(Results, Result)
				end
			until not Success
			ExecutionState:Rewind(Bookmark)
			Results = Execution.Bubble(Results)
			return true, Results
		end
	elseif self.Amount > 0 then
		if Execution.Bubble.Is(Argument) then --TODO bubble->bubble args version
		else --single->bubble
			local Results = {}
			for _ = 1, self.Amount do
				local Success, Result = Execution.Recurse(
					ExecutionState,
					"Raise", "SubPattern", self.Pattern, Argument
				)
				if Success then
					table.insert(Results, Result)
				else
					return false
				end
			end
			Results = Execution.Bubble(Results)
			return true, Results
		end
	else
		--TODO negative case
	end
end

return Repeated
