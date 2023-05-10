local OOP = require"Moonrise.OOP"
---@class Moonrise.Stream.Base
---@operator call(): Moonrise.Stream.Base
local Base = OOP.Declarator.Shortcuts(
	"Moonrise.Stream.Base", {
		require"Moonrise.Object.Optimizable"
	}
)

---@diagnostic disable-next-line:unused-local
function Base:Initialize(Instance)
end

---@return integer
function Base:At()
	---@diagnostic disable-next-line:missing-return
end

---@param Offset integer
---@diagnostic disable-next-line:unused-local
function Base:Seek(Offset)
end

---@param Position integer
---@diagnostic disable-next-line:unused-local
function Base:Goto(Position)
end

---@return integer
function Base:Size()
	---@diagnostic disable-next-line:missing-return
end

---@param Count integer
---@return string
---@diagnostic disable-next-line:unused-local
function Base:Read(Count)
	---@diagnostic disable-next-line:missing-return
end

---@param String string
---@diagnostic disable-next-line:unused-local
function Base:Write(String)
	---@diagnostic disable-next-line:missing-return
end

return Base
