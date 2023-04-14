
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Atleast : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Atleast
---@field Amount integer
local Atleast = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Atleast", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Atleast:Initialize(Instance, Amount, Pattern)
		---@diagnostic disable-next-line:undefined-field
		Atleast.Parents.Compound:Initialize(Instance, {Pattern = Pattern})
	Instance.Amount = Amount -- >0 = atmost <0 = atleast 0 = greedy
	Instance.Pattern = Pattern
end

function Atleast:Lower(CurrentState, Argument)
	if Execution.Bubble.Is(Argument) then
		local Arguments = Argument.Values
		assert(#Arguments >= self.Amount)
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
		error"Must be a bubble"
	end
end

function Atleast:Raise(CurrentState, Argument)
	if Execution.Bubble.Is(Argument) then --TODO bubble->bubble args version
		error"help"
	else -- single->bubble
		local Success, Bookmark
		local Results = {}
		repeat
			Bookmark = CurrentState:Mark()
			local Result
			Success, Result = Execution.Recurse(
				CurrentState,
				"Raise", "Pattern", self.Children.Pattern, Argument
			)
			if Success then
				table.insert(Results, Result)
			end
		until not Success
		CurrentState:Rewind(Bookmark)
		return #Results >= self.Amount, #Results >= self.Amount and Execution.Bubble(Results) or nil
	end
end

return Atleast
