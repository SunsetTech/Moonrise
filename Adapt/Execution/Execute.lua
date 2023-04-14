local Indent = 0
---@param CurrentState Adapt.Execution.State
---@param MethodName Adapt.Method
---@param At Adapt.Execution.Location
---@param Argument any
---@return boolean
---@return any
return function(CurrentState, MethodName, At, Argument)
	local StartByte = CurrentState.Buffer:At()
	if CurrentState.Debug then
		print(string.rep("\t", Indent) .."->", MethodName, At:ToPathFromParent(), Argument or "", MethodName=="Raise" and CurrentState:Peek(6) or "")
		Indent = Indent + 1
	end
	
	local Success, Result = At.Node[MethodName](At.Node, CurrentState, Argument)
	
	if CurrentState.Debug then
		local Read
		if MethodName == "Raise" then
			local StopByte = CurrentState.Buffer:At()
			local Length = StopByte-StartByte
			CurrentState.Buffer:Goto(StartByte)
			Read = CurrentState.Buffer:Read(Length)
		end
		Indent = Indent - 1
		print(string.rep("\t", Indent) ..tostring(Success).."<-", MethodName, At:ToPathFromParent(), Result,"<",Read)
	end

	return Success, Result
end
