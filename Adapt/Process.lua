local Execution = require"Moonrise.Adapt.Execution"

---@param Node Adapt.Transform.Base 
---@param MethodName Adapt.MethodName 
---@param Buffer Adapt.Stream.Base
---@param Argument any
local Process = function(Node, MethodName, Buffer, Argument, Debug)
	assert(Node ~= nil)
	local ProgramState = Execution.State(Buffer, Debug)
	ProgramState:Optimize()
	ProgramState:Link(Node)
	ProgramState.Mark = ProgramState.Mark
	print(Node)
	local Success, Result = Execution.Recurse( ProgramState, MethodName, Node, Argument)
	return Success, Result
end;

return Process
