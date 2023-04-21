local Indent = 0


---@param CurrentState Adapt.Execution.State
---@param MethodName Adapt.Method
---@param Node Adapt.Transform.Base
---@param Argument any
---@return boolean
---@return any
return function(CurrentState, MethodName, Node, Argument)--TODO cache
	print(Node, MethodName)
	assert(Node[MethodName], MethodName)
	local StartByte = CurrentState.Buffer:At()
	if CurrentState.Debug then
		print(string.rep("| ", Indent) .."->", MethodName, CurrentState.NameMap[Node], Node, Argument or "", MethodName=="Raise" and CurrentState:Peek(6) or "")
		Indent = Indent + 1
	end
	
	local Success, Result = Node[MethodName](Node, CurrentState, Argument)
	
	if CurrentState.Debug then
		local Read
		if MethodName == "Raise" then
			local StopByte = CurrentState.Buffer:At()
			local Length = StopByte-StartByte
			CurrentState.Buffer:Goto(StartByte)
			Read = CurrentState.Buffer:Read(Length)
		end
		Indent = Indent - 1
		local ReturnFormat = [[%s %s(%s): (%s, %s) <- (%s)]]
		print(string.rep("| ", Indent) .. ReturnFormat:format(MethodName, CurrentState.NameMap[Node], Node, tostring(Success), tostring(Result), Read))
	end

	return Success, Result
end
