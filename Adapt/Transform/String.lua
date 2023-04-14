local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.String : Adapt.Transform.Base
---@operator call:Adapt.Transform.String
---@field Bytes string
local String = OOP.Declarator.Shortcuts(
	"Adapt.Transform.String", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

---@param Bytes string
function String:Initialize(Instance, Bytes)
	Instance.Bytes = Bytes or ""
end

---@param CurrentState Adapt.Execution.State
---@param Input string,
function String:Lower(CurrentState, Input)
	return 
		Input == self.Bytes, 
		Input == self.Bytes and CurrentState:Write(self.Bytes)
end

---@param CurrentState Adapt.Execution.State
function String:Raise(CurrentState)
	local Input = CurrentState:Read(#self.Bytes)
	return Input == self.Bytes, Input
end

return String
