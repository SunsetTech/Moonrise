---@diagnostic disable:unused-local

local Pretty = require"Moonrise.Tools.Pretty"
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"
local Stream = require"Moonrise.Adapt.Stream"
local Process = require"Moonrise.Adapt.Process"

---@class Adapt.Transform.Left : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Left
Left = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Left", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Left:Initialize(Instance, LHS_R, LHS_NR, RHS)
---@diagnostic disable-next-line:undefined-field
		Left.Parents.Compound:Initialize(Instance, {LHS_R=LHS_R, LHS_NR=LHS_NR, LHS=LHS_R+LHS_NR, RHS=RHS})
end

--doesnt work right oops
---comment
---@param CurrentState Adapt.Execution.State
---@param Argument any
function Left:Raise(CurrentState, Argument) --Root
	print("Trying", CurrentState:Peek(10))
	Argument = Argument or {}
	local FrontStartPos = CurrentState:Position()
	local _Success, _Result = Execution.Recurse(CurrentState, "Raise", self.Children.LHS_NR, nil)
	--local _Bookmark = CurrentState:Mark()
	if _Success then
		local LeftBuffer = Stream.String""
		local FrontEndPos = CurrentState:Position()
		local FrontLength = FrontEndPos - FrontStartPos
		CurrentState.Buffer:Goto(FrontStartPos)
		LeftBuffer:Write(CurrentState:Read(FrontLength))
		print("Front", LeftBuffer.Contents)
		local SearchStartByte = CurrentState:Position()
		print("Looking for ".. tostring(self.Children.RHS))
		local RHS_Success, RHS_Result
		local SearchEndByte = SearchStartByte
		repeat
			local NextSearchEndByte = CurrentState:Position()
			RHS_Success, RHS_Result = Execution.Recurse(CurrentState, "Raise", self.Children.RHS, nil)
			if (RHS_Success) then
				SearchEndByte = NextSearchEndByte
			end
		until not RHS_Success
		CurrentState.Buffer:Goto(SearchStartByte)
		print"???"
		if SearchEndByte > SearchStartByte then
			LeftBuffer:Write(CurrentState:Read(SearchEndByte - SearchStartByte))
			LeftBuffer:Goto(1)
			local CurrentBuffer = CurrentState.Buffer
			CurrentState.Buffer = LeftBuffer
			local LHSSuccess, LHSResult = Execution.Recurse(CurrentState, "Raise", self.Children.LHS, Argument.LHS)
			CurrentState.Buffer = CurrentBuffer
			print("Left recurse got", LHSSuccess, Pretty.Any(LHSResult, true, 2))
			os.exit()
		end
	else
		return _Success, _Result
	end
	--os.exit()

	--[[Argument = Argument or {}
	local Start 
	local LeftBuffer = Stream.String""
	local _Bookmark = CurrentState:Mark()
	local _Success, _Result = Execution.Recurse(CurrentState, "Raise", self.Children.LHS_NR, Argument.LHS)

	local At = CurrentState:Position()
	CurrentState:Rewind(NR_Bookmark)
	local Length = At - CurrentState:Position()
	local Front = CurrentState:Read(Length)
	LeftBuffer:Write(Front)
	if LHS_NR_Success then
		local RHSSuccess, RHSResult
		repeat
			local Bookmark = CurrentState:Mark()
			RHSSuccess, RHSResult = Execution.Recurse(CurrentState, "Raise", self.Children.RHS, Argument.RHS) --TODO pass a better idea
			if not RHSSuccess then
				CurrentState:Rewind(Bookmark)
				local Byte = CurrentState:Read(1)
				if Byte then
					LeftBuffer:Write(Byte)
				else
					break
				end
			end
		until not RHSSuccess
		if RHSSuccess then
			LeftBuffer:Goto(1)
			local CurrentBuffer = CurrentState.Buffer
			CurrentState.Buffer = LeftBuffer
			print(LeftBuffer.Contents)
			local LHSSuccess, LHSResult = Execution.Recurse(CurrentState, "Raise", self.Children.LHS, Argument.LHS)
			CurrentState.Buffer = CurrentBuffer
			return LHSSuccess, LHSSuccess and {LHS=LHSResult, RHS=RHSResult}
		else
			return false
		end
	else
		return false
	end]]
end

function Left:Lower()
	error"NYI"
	--[[return Execution.Recurse(CurrentState, "Lower", "1", self.Children[1], Argument)]]
end

return Left

