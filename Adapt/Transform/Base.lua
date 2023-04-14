local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.Base
---@operator call(): Adapt.Transform.Base 
local Base = OOP.Declarator.Shortcuts"Adapt.Transform.Base"

function Base:Initialize()
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
---@diagnostic disable-next-line:unused-local 
function Base:Lower(CurrentState, Argument) ---@diagnostic disable-line:unused-vararg
	error":Lower not implemented"
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
---@diagnostic disable-next-line:unused-local
function Base:Raise(CurrentState, Argument) ---@diagnostic disable-line:unused-vararg
	error":Raise not implemented"
end

function Base:Optimize()
	--print("Optimizing", self)
	self.Raise = self.Raise
	self.Lower = self.Lower
end

return Base
