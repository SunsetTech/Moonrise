local Available, MutableBuffer = pcall(require,"MutableBuffer")
if not Available then return end

local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

---@class Moonrise.Stream.Buffer : Moonrise.Stream.Base
---@operator call:Moonrise.Stream.Buffer
---@field public Contents string
---@field private Position integer
local Buffer = OOP.Declarator.Shortcuts(
	"Moonrise.Stream.Buffer", {
		require"Moonrise.Stream.Base"
	}
)

function Buffer:Initialize(Instance, Content)
	Instance.Handle = MutableBuffer.New()
	Instance.Handle:Write(Content or "")
	Instance.Position = 1
end

---@return integer
function Buffer:At()
	return self.Position
end

function Buffer:Seek(Offset)
	self.Position = self.Position + Offset
end

function Buffer:Goto(Position)
	self.Position = Position
end

---@return integer
function Buffer:Size()
	return self.Handle:Size()
end

---@param Bytes integer
---@return string | boolean
function Buffer:Read(Bytes)
	local Content = self.Handle:Read(self.Position, self.Position+Bytes-1)
	self.Position = self.Position + Bytes
	return Content
end

---@param Contents string
function Buffer:Write(Contents)
	self.Handle:Write(Contents, self.Position)
	self.Position = self.Position + #Contents
end

return Buffer

