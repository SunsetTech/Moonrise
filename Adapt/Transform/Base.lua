local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Base = OOP.Declarator.Shortcuts"Adapt.Element.Base"

function Base:Initialize()
end

function Base:Left(Processor, ...)
	error"<< not implemented"
end

function Base:Right(Processor, ...)
	error">> not implemented"
end

return Base
