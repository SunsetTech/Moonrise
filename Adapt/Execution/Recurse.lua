local Recurse = function(ExecutionState, MethodName, NodeName, Node, Argument)
	local Success, Result
	
	do ExecutionState:Push(NodeName, Node)
		Success, Result = Node[MethodName](Node, ExecutionState, Argument)
	end ExecutionState:Pop(NodeName)
	
	return Success, Result
end

return Recurse

