local Execute = require"Moonrise.Adapt.Execution.Execute"
---@param CurrentState Adapt.Execution.State
---@param MethodName Adapt.MethodName
---@param NodeName string
---@param Node Adapt.Transform.Base
---@param Argument any
---@return boolean, any
local Recurse = function(CurrentState, MethodName, NodeName, Node, Argument)
	local At = CurrentState:AppendLocation(NodeName, Node)
		local Success, Result = Execute(CurrentState, MethodName, At, Argument)--Node[MethodName](Node, CurrentState, Argument)
	if At.Parent then At.Parent:Pop(At) end

	return Success, Result
end

return Recurse

