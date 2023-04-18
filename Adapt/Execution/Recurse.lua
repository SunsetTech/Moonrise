local Execute = require"Moonrise.Adapt.Execution.Execute"
local LocationAllocator = require"Moonrise.Adapt.Optimization.LocationAllocator"
---@param CurrentState Adapt.Execution.State
---@param MethodName Adapt.MethodName
---@param NodeName string
---@param Node Adapt.Transform.Base
---@param Argument any
---@return boolean, any
local Recurse = function(CurrentState, MethodName, NodeName, Node, Argument)
	local At = CurrentState:AppendLocation(NodeName, Node)
		local Success, Result = Execute(CurrentState, MethodName, At, Argument)
	if At.Parent then At.Parent:Pop(At) end
	LocationAllocator.Deallocate(At)

	return Success, Result
end

return Recurse

