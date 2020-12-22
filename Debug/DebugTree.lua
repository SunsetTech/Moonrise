local OOP = require("Toolbox.OOP")

local Prototype, Class = OOP.Create(
	"DebugTree",
	OOP.InheritModules{
		"Toolbox.Structures.Interfaces.PipeTree"
	}
)

function Prototype:Add(Message,Tags,Offset)
	assert(type(Message) == "string","Expected a string")
	Offset = Offset or 0
	self:Write{
		Info = debug.getinfo(2+Offset);
		Message = Message;
		Tags = Tags;
	}
end

return Class

