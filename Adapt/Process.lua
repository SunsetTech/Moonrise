local Execution = require"Moonrise.Adapt.Execution"

---@param Node Adapt.Transform.Base 
---@param MethodName Adapt.MethodName 
---@param Buffer Adapt.Stream.Base
---@param Argument any
return function(Node, MethodName, Buffer, Argument, Debug, NameMap, JumpMap, IgnoreDebug) --TODO allow reusing state or parts thereof?
	assert(Node ~= nil)
	local ProgramState = Execution.State(Buffer, Debug, IgnoreDebug)
	ProgramState.NameMap = NameMap or ProgramState.NameMap
	ProgramState.JumpMap = JumpMap or ProgramState.JumpMap
	ProgramState:Optimize()
	ProgramState:Link(Node)
	ProgramState.Mark = ProgramState.Mark
	local Success, Result = Execution.Recurse( ProgramState, MethodName, Node, Argument)
	return Success, Result, ProgramState.NameMap, ProgramState.JumpMap
end;
