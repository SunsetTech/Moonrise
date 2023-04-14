
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.All : Adapt.Transform.Compound
---@operator call:Adapt.Transform.All
---@field Amount integer
local All = OOP.Declarator.Shortcuts(
	"Adapt.Transform.All", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

---comment
---@param Instance Adapt.Transform.All
---@param Pattern Adapt.Transform.Base
function All:Initialize(Instance, Pattern)
		---@diagnostic disable-next-line:undefined-field
		All.Parents.Compound:Initialize(Instance, {Pattern = Pattern})
	Instance.Pattern = Pattern
end

function All:Lower(CurrentState, Argument)
	if Execution.Bubble.Is(Argument) then --bubble->bubble
		local Arguments = Argument.Values
		local Results = {}
		
		local Success
		for Index = 1, #Arguments do
			local _Argument = Arguments[Index]
		--for _, _Argument in pairs(Arguments) do
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

function All:Raise(CurrentState, Argument)
	if Execution.Bubble.Is(Argument) then --TODO bubble->bubble args version
		error"help"
	else -- single->bubble
		local Success, Bookmark
		local Results = {}
		repeat
			if Bookmark then 
				CurrentState:ClearMark(Bookmark)
			end
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
		Results = Execution.Bubble(Results)
		return true, Results
	end
end

return All
