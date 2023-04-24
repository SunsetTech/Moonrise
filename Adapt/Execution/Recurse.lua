local Indent = 0

local function GetMatched(CurrentState, StartByte)
	local StopByte = CurrentState.Buffer:At()
	local Length = StopByte-StartByte
	CurrentState.Buffer:Goto(StartByte)
	return CurrentState.Buffer:Read(Length)
end

---@param CurrentState Adapt.Execution.State
---@param MethodName Adapt.Method
---@param Node Adapt.Transform.Base
---@param Argument any
---@return boolean
---@return any
return function(CurrentState, MethodName, Node, Argument)--TODO cache
	local StartByte = CurrentState.Buffer:At()
	local StartNode = Node
	if CurrentState.Debug and not CurrentState.IgnoreDebug[StartNode] then
		print(string.rep("  ", Indent) .."->", MethodName, CurrentState.NameMap[Node], Node, Argument or "", MethodName=="Raise" and CurrentState:Peek(6) or "")
		Indent = Indent + 1
	end
	
	local Success, Result
	repeat
		Success, Result, Node, Argument = Node[MethodName](Node, CurrentState, Argument)
	until not Node
	
	if CurrentState.Debug and not CurrentState.IgnoreDebug[StartNode] then
		local Read
		if MethodName == "Raise" then Read = GetMatched(CurrentState, StartByte) end
		Indent = Indent - 1
		local ReturnFormat = [[%s %s(%s): (%s, %s) <- (%s)]]
		print(string.rep("  ", Indent) .. ReturnFormat:format(MethodName, CurrentState.NameMap[StartNode], StartNode, tostring(Success), tostring(Result), Read))
	end

	return Success, Result
end
