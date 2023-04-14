

local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"
local Stream = require"Moonrise.Adapt.Stream"
local Process = require"Moonrise.Adapt.Process"
---@class Adapt.Transform.Invert : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Invert
Invert = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Invert", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Invert:Initialize(Instance, LHS, RHS)
---@diagnostic disable-next-line:undefined-field
		Invert.Parents.Compound:Initialize(Instance, {LHS=LHS, RHS=RHS})
end

---comment
---@param CurrentState Adapt.Execution.State
---@param Argument any
function Invert:Raise(CurrentState, Argument)

end

--doesnt work right oops
--[[---comment
---@param CurrentState Adapt.Execution.State
---@param Argument any
function Invert:Raise(CurrentState, Argument) --Root
	Argument = Argument or {}
	local InvertBuffer = Stream.String""
	local RHSSuccess, RHSResult
	repeat
		local Bookmark = CurrentState:Mark()
		RHSSuccess, RHSResult = Execution.Recurse(CurrentState, "Raise", "RHS", self.Children.RHS, Argument.RHS) --TODO pass a better idea
		if not RHSSuccess then
			CurrentState:Rewind(Bookmark)
			local Byte = CurrentState:Read(1)
			if Byte then
				InvertBuffer:Write(Byte)
			else
				break
			end
		end
	until RHSSuccess
	if RHSSuccess then
		InvertBuffer:Goto(1)
		local CurrentBuffer = CurrentState.Buffer
		CurrentState.Buffer = InvertBuffer
		local LHSSuccess, LHSResult = Execution.Recurse(CurrentState, "Raise", "LHS", self.Children.LHS, Argument.LHS)
		CurrentState.Buffer = CurrentBuffer
		return LHSSuccess, LHSSuccess and {LHS=LHSResult, RHS=RHSResult}
	else
		return false
	end
end]]

function Invert:Lower(CurrentState, Argument)
	--[[return Execution.Recurse(CurrentState, "Lower", "1", self.Children[1], Argument)]]
end

return Invert

