local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

---@class Adapt.Stream.File : Adapt.Stream.Base
---@operator call:Adapt.Stream.File
---@field Handle file*
local File = OOP.Declarator.Shortcuts(
	"Adapt.Stream.File", {
		Module.Sister"Base"
	}
)

---@param Path string
---@param Mode string #TODO better type for this
function File:Initialize(Instance, Path, Mode)
	local Handle = io.open(Path, Mode)
	assert(Handle)
	Instance.Handle = Handle
	Instance.At = File.At
	Instance.Seek = File.Seek
	Instance.Goto = File.Goto
	Instance.Size = File.Size
	Instance.Read = File.Read
	Instance.Write = File.Write
end

---@return integer
function File:At()
	return self.Handle:seek"cur"
end

function File:Seek(Offset)
	self.Handle:seek("cur", Offset)
end

function File:Goto(Position)
	self.Handle:seek("set", Position)
end

---@return integer
function File:Size()
	local Current = self:At()
	local Size = self.Handle:seek"end"
	
	self.Handle:seek("set", Current)
	
	return Size
end

---@param Bytes integer
---@return string
function File:Read(Bytes)
	return self.Handle:read(Bytes)
end

---@param Contents string
function File:Write(Contents)
	self.Handle:write(Contents)
end

return File
