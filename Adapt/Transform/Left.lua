local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"
local Stream = require"Moonrise.Adapt.Stream"

local Success = require"Moonrise.Adapt.Transform.Success"
local BasicFilters = require"Moonrise.Grammar.Filters"

---@class Adapt.Transform.Left : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Left
Left = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Left", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Left:Initialize(Instance, LHS_R, LHS_NR, RHS, Join) --TODO accept join character seperately?
---@diagnostic disable-next-line:undefined-field
		Left.Parents.Compound:Initialize(
			Instance, {
				LHS_R=LHS_R;
				LHS_NR=LHS_NR;
				LHS=(LHS_R+LHS_NR)/BasicFilters.Select;
				Base=LHS_NR * RHS;
				RHS=RHS;
				Join=Join or Success(true);
			}
		)
end

--doesnt work right oops
---comment
---@param CurrentState Adapt.Execution.State
---@param Argument any
function Left:Raise(CurrentState, Argument) --Root
	Argument = Argument or {}
	
	--Ghost match LHS_NR to align
	local FrontMark = CurrentState:Mark()
	local FrontSuccess = Execution.Recurse(CurrentState, "Raise", self.Children.LHS_NR, nil)
	
	if FrontSuccess then
		local RHSSuccess = false
		local RHSLastEnd
		repeat --Eat RHS until we cant, record the start of the last one
			local RHSNextEnd = CurrentState:Position()
			RHSSuccess = Execution.Recurse(CurrentState, "Raise", self.Children.RHS, nil)
			if RHSSuccess then
				RHSLastEnd = RHSNextEnd
			end
		until not RHSSuccess
		
		if RHSLastEnd then --Found atleast one RHS, recurse
			CurrentState:Rewind(FrontMark)
			
			local LeftBuffer = Stream.String(CurrentState:Read(RHSLastEnd - CurrentState:Position()))
			
			local CurrentBuffer = CurrentState.Buffer
			CurrentState.Buffer = LeftBuffer
				local LeftSuccess, LeftResult = Execution.Recurse(CurrentState, "Raise", self.Children.LHS, Argument.LHS)
			CurrentState.Buffer = CurrentBuffer
			
			if LeftSuccess then
				local RightSuccess, RightResult = Execution.Recurse(CurrentState, "Raise", self.Children.RHS, Argument.RHS)
				return RightSuccess, RightSuccess and {LHS = LeftResult, RHS = RightResult}
			end
		else --No RHS found, try the non recursive case
			print"???"
			return Execution.Recurse(CurrentState, "Raise", self.Children.LHS_NR, Argument.LHS)
		end
	else
		return false
	end
end

function Left:Lower()
	error"NYI"
	--[[return Execution.Recurse(CurrentState, "Lower", "1", self.Children[1], Argument)]]
end

return Left

