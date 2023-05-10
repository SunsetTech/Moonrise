
local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

---@class Moonrise.Stream.String : Moonrise.Stream.Base
---@operator call:Moonrise.Stream.String
---@field public Contents string
---@field private Position integer
local String = OOP.Declarator.Shortcuts(
	"Moonrise.Stream.String", {
		require"Moonrise.Stream.Base"
	}
)

function String:Initialize(Instance, Contents)
	Instance.Contents = Contents
	Instance.Position = 1
end

---@return integer
function String:At()
	return self.Position
end

function String:Seek(Offset)
	self.Position = self.Position + Offset
end

function String:Goto(Position)
	self.Position = Position
end

---@return integer
function String:Size()
	return #self.Contents
end

---@param Bytes integer
---@return string | boolean
function String:Read(Bytes)
	if self.Position <= self:Size() then
		local Substring = self.Contents:sub(self.Position, self.Position+Bytes-1)
		self.Position = self.Position + Bytes
		return Substring
	else
		return false
	end
end

---@param Contents string
function String:Write(Contents)
	assert(type(Contents) == "string")
	local Prefix = self.Contents:sub(1, self.Position-1)
	local EndByte = self.Position + #Contents
	local Suffix = self.Contents:sub(self.Position+#Contents, EndByte > self:Size() and EndByte or self:Size())
	self.Contents = Prefix .. Contents .. Suffix
	self.Position = EndByte
end

return String
