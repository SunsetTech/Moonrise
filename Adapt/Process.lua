local Execution = require"Moonrise.Adapt.Execution"

---@param Node Adapt.Transform.Base 
---@param MethodName Adapt.MethodName 
---@param Buffer Adapt.Stream.Base
---@param Argument any
local Process = function(Node, MethodName, Buffer, Argument, Debug)
	assert(Node ~= nil)
	--only users should only use this
	--module internals should use Recurse
	local ProgramState = Execution.State(Buffer, Debug)
	ProgramState.Mark = ProgramState.Mark
	local Success, Result = Execution.Recurse(
		ProgramState, 
		MethodName, "Program", 
		Node, Argument
	)
	
	return Success, Result
end;

return Process
