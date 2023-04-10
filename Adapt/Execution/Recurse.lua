---@param CurrentState Adapt.Execution.State
local Recurse = function(CurrentState, MethodName, NodeName, Node, Argument, aaa)
	local Success, Result
	local At = CurrentState:AppendLocation(NodeName, Node)
		Success, Result = Node[MethodName](Node, CurrentState, Argument)
	if At.Parent then At.Parent:Pop(At) end
	
	return Success, Result
end

return Recurse

