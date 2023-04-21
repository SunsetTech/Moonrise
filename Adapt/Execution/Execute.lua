local Indent = 0

---@param State Adapt.Execution.State
---@param Node Adapt.Transform.Base
---@param Argument any
local function CacheLookup(State, Node, Argument)
	local Cache = State.RaiseCache
	local Position = State.Buffer:At()
	Cache[Position] = Cache[Position] or {}
	Cache[Position][Node] = Cache[Position][Node] or {}
	Cache[Position][Node][Argument or "nil"] = Cache[Position][Node][Argument or "nil"] or {}
	return Cache[Position][Node][Argument or "nil"]
end

local function CacheStore(State, Node, Argument, Success, Result)
	local CacheEntry = CacheLookup(State, Node, Argument)
	CacheEntry.Success = Success
	CacheEntry.Result = Result
end

---@param CurrentState Adapt.Execution.State
---@param MethodName Adapt.Method
---@param At Adapt.Execution.Location
---@param Argument any
---@return boolean
---@return any
return function(CurrentState, MethodName, At, Argument)--TODO cache
	local StartByte = CurrentState.Buffer:At()
	if CurrentState.Debug then
		print(string.rep("| ", Indent) .."->", MethodName, At:ToPathFromParent(), At.Node, Argument or "", MethodName=="Raise" and CurrentState:Peek(6) or "")
		Indent = Indent + 1
	end
	
	local Success, Result
	--local CacheEntry = CacheLookup(CurrentState, At.Node, Argument)
	if MethodName == "raise" and CacheEntry then
		--Success, Result = CacheEntry.Success, CacheEntry.Result
	else
		Success, Result = At.Node[MethodName](At.Node, CurrentState, Argument)
		--CacheStore(CurrentState, At.Node, Argument, Success, Result)
	end
	
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
		print(string.rep("| ", Indent) .. ReturnFormat:format(MethodName, At:ToPathFromParent(), At.Node, tostring(Success), tostring(Result), Read))
		--print(string.rep("\t", Indent) ..tostring(Success).."<-", MethodName, At:ToPathFromParent(), Result,"<",Read)
	end

	return Success, Result
end
