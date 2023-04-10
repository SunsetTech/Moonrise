local OOP = require"Moonrise.OOP"

local Packed = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Packed", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

function Packed:Initialize(Instance, Format)
	Instance.Format = Format
end

local function DropLast(Value, ...)
	if select("#", ...) > 1 then
		return Value, DropLast(...)
	else
		return Value
	end
end

function Packed:Raise(ExecutionState)
	local PackSize = string.packsize(self.Format)
	
	local Input = ExecutionState:Read(PackSize)
	
	return true, {DropLast(string.unpack(self.Format, Input))}
end

function Packed:Lower(ExecutionState, ...)
	return true, ExecutionState:Write(
		string.pack(self.Format, ...)
	)
end

return Packed
