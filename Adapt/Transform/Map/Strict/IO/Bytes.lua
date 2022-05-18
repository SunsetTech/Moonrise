local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Bytes = OOP.Declarator.Shortcuts(
	"Adapt.Element.Bytes", {
		Module.Sister"Base"
	}
)

function Bytes:Initialize(Instance, Format)
	Instance.Format = Format
end

local function DropLast(Value, ...)
	if select("#", ...) > 1 then
		return Value, DropLast(...)
	else
		return Value
	end
end

function Bytes:Split(Processor)
	local PackSize = string.packsize(self.Format)
	
	local Input = Processor:Read(PackSize)
	
	return true, DropLast(string.unpack(self.Format, Input))
end

function Bytes:Fuse(Processor, ...)
	return true, Processor:Write(
		string.pack(self.Format, ...)
	)
end

return Bytes
