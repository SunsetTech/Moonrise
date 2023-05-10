
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
end

function All:Lower(CurrentState, Arguments)
	if Execution.Bubble.Is(Arguments) then --bubble->bubble
		local Results = Execution.Bubble.Form()
		
		local Success
		for Index = 1, #Arguments do
			local Argument = Arguments[Index]
			local Result
			Success, Result = Execution.Recurse(
				CurrentState,
				"Lower", self.Children.Pattern, Argument
			)
			if Success then
				table.insert(Results, Result)
			else
				print(Argument, Argument[Index], self.Children.Pattern)
				error"oh no"
			end
		end
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
		local Results = Execution.Bubble.Form()
		repeat
			Bookmark = CurrentState:Mark()
			local Result
			Success, Result = Execution.Recurse(
				CurrentState,
				"Raise", self.Children.Pattern, Argument
			)
			if Success then
				table.insert(Results, Result)
			end
		until not Success
		CurrentState:Rewind(Bookmark)
		return true, Results
	end
end

function All:__tostring()
	return tostring(self.Children.Pattern) .."^0"
end

return All
