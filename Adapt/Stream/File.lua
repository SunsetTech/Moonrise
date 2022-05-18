local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local File = OOP.Declarator.Shortcuts(
	"Adapt.Stream.File", {
		Module.Sister"Base"
	}
)

function File:Initialize(Instance, Path, Mode)
	Instance.Handle = io.open(Path, Mode)
end

function File:At()
	return self.Handle:seek"cur"
end

function File:Seek(Offset)
	return self.Handle:seek("cur", Offset)
end

function File:Goto(Position)
	return self.Handle:seek("set", Position)
end

function File:Size()
	local Current = self:At()
	local Size = self.Handle:seek"end"
	
	self.Handle:seek("set", Current)
	
	return Size
end

function File:Read(Bytes)
	return self.Handle:read(Bytes)
end

function File:Write(Substring)
	return self.Handle:write(Substring)
end

return File
