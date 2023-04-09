local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Base = OOP.Declarator.Shortcuts"Adapt.Element.Base"

function Base:Initialize()
end

Base.Join = function(ExecutionState, ...)
		error":Join not implemented"
	end


Base.Split = function(ExecutionState, ...)
		error":Split not implemented"
	end



return Base
