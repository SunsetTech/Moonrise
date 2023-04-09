local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Packed = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Packed", {
		Module.Sister"Base"
	}
)

function Packed:Initialize(Instance, Packed)
	Instance.Packed = Packed
end

local function DropLast(Value, ...)
	if select("#", ...) > 1 then
		return Value, DropLast(...)
	else
		return Value
	end
end

function Packed:Raise(Processor)
	local PackSize = string.packsize(self.Packed)
	
	local Input = Processor:Read(PackSize)
	
	return true, DropLast(string.unpack(self.Packed, Input))
end

function Packed:Lower(Processor, ...)
	return true, Processor:Write(
		string.pack(self.Packed, ...)
	)
end

return Packed
