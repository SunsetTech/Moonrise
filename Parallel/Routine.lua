local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Routine = OOP.Declarator.Shortcuts"Threading.Routine"

function Routine:InitializeThread()
end

function Routine:Step()
	error"not implemented"
end

function Routine:Loop()
	while true do 
		self:Step()
	end
end

function Routine:Start(...)
	self:InitializeThread(...)
	self:Loop()
end

return Routine
