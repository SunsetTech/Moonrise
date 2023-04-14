local OOP = require"Moonrise.OOP"

local Range = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Range", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

function Range:Initialize(Instance, Start, End)
	Instance.Start = type(Start) == "string" and string.byte(Start) or Start
	Instance.End = type(End) == "string" and string.byte(End) or End
end

function Range:Raise(CurrentState)
	local Input = CurrentState:Read(1)
	if Input then
		local Byte = string.byte(Input)
		local Matches = Byte >= self.Start and Byte <= self.End
		return Matches, Input
	else
		return false
	end
end

function Range:Lower(CurrentState, Input)
	if type(Input) == "string" and #Input == 1 then
		--[[if type(Input) == "table" then
			debug.debug()
		end]]
		local Byte = string.byte(Input)
		local Matches = Byte >= self.Start and Byte <= self.End
		return Matches, Matches and CurrentState:Write(Input)
	end
end

return Range
