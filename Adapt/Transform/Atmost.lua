
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Atmost : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Atmost
---@field Amount integer
local Atmost = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Atmost", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Atmost:Initialize(Instance, Amount, Pattern)
		---@diagnostic disable-next-line:undefined-field
		Atmost.Parents.Compound:Initialize(Instance, {Pattern = Pattern})
	Instance.Amount = Amount -- >0 = atmost <0 = atleast 0 = greedy
	Instance.Pattern = Pattern
end

function Atmost:Lower(CurrentState, Argument)
	if Execution.Bubble.Is(Argument) then
		local Arguments = Argument.Values
		if #Arguments <= self.Amount then
			local Results = {}
			
			local Success
			for _, _Argument in pairs(Arguments) do
				local Result
				Success, Result = Execution.Recurse(
					CurrentState,
					"Lower", "Pattern", self.Children.Pattern, _Argument
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
			return false
		end
	else
		error"Must be a bubble"
	end
end

function Atmost:Raise(CurrentState, Argument)
	if Execution.Bubble.Is(Argument) then --TODO bubble->bubble args version
		error"help"
	else --single->bubble
		local Results = {}
		for _ = 1, self.Amount do
			local Bookmark = CurrentState:Mark()
			local Success, Result = Execution.Recurse(
				CurrentState,
				"Raise", "Pattern", self.Children.Pattern, Argument
			)
			if Success then
				table.insert(Results, Result)
			else
				CurrentState:Rewind(Bookmark)
				break
			end
		end
		Results = Execution.Bubble(Results)
		return true, Results
	end
end

return Atmost
