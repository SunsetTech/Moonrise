local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Base = OOP.Declarator.Shortcuts"Adapt.Stream.Base"

function Base:Initialize(Instance)
end

function Base:At()
end

function Base:Seek(Offset)
end

function Base:Goto(Position)
end

function Base:Size()
end

function Base:Read(Bytes)
end

function Base:Write(Substring)
end

return Base
