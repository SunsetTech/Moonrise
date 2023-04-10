local Execution = require"Moonrise.Adapt.Execution"

---@param Node Adapt.Transform.Base 
---@param MethodName string 
---@param Buffer Adapt.Stream.Base
---@param Argument any
local Process = function(Node, MethodName, Buffer, Argument) 
	--only users should only use this
	--module internals should use Recurse
	local ProgramState = Execution.State(Buffer)
	
	local Success, Result = Execution.Recurse(
		ProgramState, 
		MethodName, "Program", 
		Node, Argument
	)
	
	return Success, Result
end;

return Process
