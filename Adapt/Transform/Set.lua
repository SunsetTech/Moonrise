local Tools = {
	String = require"Moonrise.Tools.String"
}
local OOP = require"Moonrise.OOP"

local Set = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Set", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

function Set:Initialize(Instance, Chars)
	Instance._Chars = Chars
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

function Set:__tostring()
	return 'Set"'.. self._Chars ..'"'
end

return Set
