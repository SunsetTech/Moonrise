
local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.Bytes : Adapt.Transform.Base
---@operator call:Adapt.Transform.Bytes
---@field Count integer
local Bytes = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Bytes", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

---@param Count integer
function Bytes:Initialize(Instance, Count)
	Instance.Count = Count or 1
end

---@param CurrentState Adapt.Execution.State
---@param Input string,
function Bytes:Lower(CurrentState, Input)
	return 
		Input and #Input == self.Count, 
		Input and #Input == self.Count and CurrentState:Write(Input)
end

---@param CurrentState Adapt.Execution.State
function Bytes:Raise(CurrentState)
	local Input = CurrentState:Read(self.Count)
	--[[if Input == nil then
		return false
	end]]
	--Input = Input == nil and false
	return Input and #Input == self.Count or false, Input
end

function Bytes:__tostring()
	return "Bytes(".. self.Count ..")"
end

return Bytes
