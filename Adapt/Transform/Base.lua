local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.Base
---@operator call(): Adapt.Transform.Base 
local Base = OOP.Declarator.Shortcuts"Adapt.Transform.Base"

---@return nil
function Base:Initialize()
end

---@param ExecutionState Adapt.Execution.State
---@param ... any
---@diagnostic disable-next-line:unused-local 
function Base:Join(ExecutionState, ...) ---@diagnostic disable-line:unused-vararg
	error":Join not implemented"
end

---@param ExecutionState Adapt.Execution.State
---@param ... any
---@diagnostic disable-next-line:unused-local
function Base:Split(ExecutionState, ...) ---@diagnostic disable-line:unused-vararg
	error":Split not implemented"
end



return Base
