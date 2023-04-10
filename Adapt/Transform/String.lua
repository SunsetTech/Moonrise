local OOP = require"Moonrise.OOP"

local String = OOP.Declarator.Shortcuts(
	"Adapt.Transform.String", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

function String:Initialize(Instance, Bytes)
	Instance.Bytes = Bytes or ""
end

function String:Lower(State, Input)
	return 
		Input == self.Bytes, 
		Input == self.Bytes and State:Write(self.Bytes)
end

function String:Raise(State)
	local Input = State:Read(#self.Bytes)
	return Input == self.Bytes, Input
end

return String
