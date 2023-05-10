local Execution = require"Moonrise.Adapt.Execution"

---@param Node Adapt.Transform.Base 
---@param MethodName Adapt.MethodName 
---@param Buffer Moonrise.Stream.Base
---@param Argument any
---@param Debug boolean
---@param NameMap table
---@param JumpMap table
---@param IgnoreDebug table<Adapt.Transform.Base,boolean>
return function(Node, MethodName, Buffer, Argument, Debug, NameMap, JumpMap, IgnoreDebug) --TODO allow reusing state or parts thereof?
	assert(Node ~= nil)
	local ProgramState = Execution.State(Buffer, Debug, IgnoreDebug)
	ProgramState.NameMap = NameMap or ProgramState.NameMap
	ProgramState.JumpMap = JumpMap or ProgramState.JumpMap
	ProgramState:Optimize()
	Buffer:Optimize()
	ProgramState:Link(Node)
	ProgramState.Mark = ProgramState.Mark
	print"Begin.."
	local Success, Result = Execution.Recurse( ProgramState, MethodName, Node, Argument)
	return Success, Result, ProgramState.NameMap, ProgramState.JumpMap
end;
