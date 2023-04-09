local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Range = OOP.Declarator.Shortcuts(
	"Adapt.Element.Range", {
		Module.Sister"Base"
	}
)

function Range:Initialize(Instance, Start, End)
	Instance.Start = Start
	Instance.End = End
end

function Range:Lower(ExecutionState, Input)
	assert(#Input == 1)
	local Byte = string.byte(Input)
	local Matches = Byte >= self.Start and Byte <= self.End
	return Matches, Matches and ExecutionState:Write(Input)
end

function Range:Raise(ExecutionState)
	local Input = ExecutionState:Read(1)
	if Input then
		local Byte = string.byte(Input)
		local Matches = Byte >= self.Start and Byte <= self.End
		return Matches, Input
	else
		return false
	end
end

return Range
