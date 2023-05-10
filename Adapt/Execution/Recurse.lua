local Terminal = require"Moonrise.Tools.Terminal"

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
	assert(Node)
	local StartByte = CurrentState.Buffer:At()
	local StartNode = Node
	if CurrentState.Debug and not CurrentState.IgnoreDebug[StartNode] then
		print(string.rep("  ", Indent) .."->", MethodName, CurrentState.NameMap[Node], Node, Argument or "", MethodName=="Raise" and '<'..Terminal.Format((CurrentState:Peek(6) or "?"):gsub("\n","\\n"), {Terminal.Color.FG.Yellow})..">" or "")
		Indent = Indent + 1
	end
	
	local Success, Result
	if MethodName == "Raise" then
		--[[local MemoEntry, LeftRecursive = CurrentState:GetMemoEntry(CurrentState.NameMap[Node]) --Memoization disabled until i can make it a flag because it slows the fuck down and consumes a lot of memory on certain patterns
		if MemoEntry.Success ~= nil then
			Success, Result = MemoEntry.Success, MemoEntry.Result
			if Success then
				CurrentState:Goto(MemoEntry.Next)
			end
		else]]
			Success, Result = Node:Raise(CurrentState, Argument)
			--[[MemoEntry.Success, MemoEntry.Result, MemoEntry.Next = Success, Result, CurrentState:Position()
		end]]
	else
		repeat
			Success, Result, Node, Argument = Node:Lower(CurrentState, Argument)
		until not Node
	end
	--until not Node
	
	if CurrentState.Debug and not CurrentState.IgnoreDebug[StartNode] then
		local Read
		if MethodName == "Raise" then Read = GetMatched(CurrentState, StartByte) end
		Indent = Indent - 1
		local ReturnFormat = [[%s %s(%s): (%s, %s) <- (%s)]]
		print(
			string.rep("  ", Indent) .. ReturnFormat:format(
				MethodName, 
				CurrentState.NameMap[StartNode], 
				StartNode, 
				Success == false and Terminal.Format("false", {Terminal.Color.FG.Red}) or Terminal.Format("true", {Terminal.Color.FG.Green}), 
				tostring(Result), 
				Terminal.Format((Read or "?"):gsub("\n","\\n"), {Terminal.Color.FG.Blue})
			)
		)
	end
	Success = Success == nil and false or Success
	return Success, Result
end
