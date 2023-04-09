local Tools = {
	String = require"Moonrise.Tools.String"
}
local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Set = OOP.Declarator.Shortcuts(
	"Adapt.Element.Set", {
		Module.Sister"Base"
	}
)

function Set:Initialize(Instance, Chars)
	Instance.Chars = {}
	for _, Char in pairs(Tools.String.Explode(Chars)) do
		Instance.Chars[Char] = true
	end
end

function Set:Lower(ExecutionState, Input)
	assert(#Input == 1)
	local Matches = self.Chars[Input]
	return Matches, Matches and ExecutionState:Write(Input)
end

function Set:Raise(ExecutionState)
	local Input = ExecutionState:Read(1)
	local Matches = self.Chars[Input]
	return Matches, Input
end

return Set
