local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local String = OOP.Declarator.Shortcuts(
	"Adapt.Element.String", {
		Module.Sister"Base"
	}
)

function String:Initialize(Instance, Contents)
	Instance.Contents = Contents or ""
end

function String:Fuse(Processor, Input)
	return Input == self.Contents, Processor:Write(self.Contents)
end

function String:Split(Processor)
	local Input = Processor:Read(#self.Contents)
	
	return Input == self.Contents, Input
end

return String
