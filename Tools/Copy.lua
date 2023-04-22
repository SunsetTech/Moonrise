local Function = require"Moonrise.Tools.Function"

local Copy = {}

function Copy.Table(RHS, Flags, Cache)
	local LHS = {}
	
	for Key, Value in pairs(RHS) do
		Key = Flags.Tables.Keys and Copy.Value(Key, Flags, Cache) or Key
		Value = Flags.Tables.Values and Copy.Value(Value, Flags, Cache) or Value
		
		LHS[Key] = Value
	end
	
	return LHS
end

local function ForUpvalues(Function)
	return coroutine.wrap(
		function()
			local Index = 1
			local Name, Value
			repeat
				Name, Value = debug.getupvalue(Function,Index)
				if Name then
					coroutine.yield(Index,Name,Value)
				end
				Index = Index + 1
			until Name == nil
		end
	)
end

function Copy.Function(Function,Env,ShareUpvalues)
	local Dump = string.dump(Function)
	local _Copy = load(Dump,"Copy","b")
	if debug.setfenv and Env then
		debug.setfenv(_Copy, Env)
	end
	for Index,Name,Value in ForUpvalues(Function) do
		local SetName = debug.getupvalue(_Copy,Index)
		if not debug.setfenv and Env and Name == "_ENV" then
			debug.setupvalue(_Copy,Index,Env)
		else
			if ShareUpvalues then
				debug.upvaluejoin(_Copy,Index,Function,Index)
			else
				debug.setupvalue(_Copy,Index,Value)
			end
		end
	end
	return _Copy
end

function Copy.Value(RHS, Flags, Cache)
	Cache = Cache or {}
	Flags = Flags or {}

	Flags.Objects = Flags.Objects == nil and {} or Flags.Objects
	Flags.Tables = Flags.Tables == nil and {} or Flags.Tables
	Flags.Functions = Flags.Functions ~= nil and Flags.Function or false
	
	
	local LHS = Cache[RHS]
	
	if not LHS then
		local Type = type(RHS)
		local Definition = getmetatable(RHS) or {}
		
		if Definition.__copy and Flags.Objects then
			LHS = Definition.__copy(RHS, Flags, Cache)
		elseif Type == "table" and Flags.Tables then
			LHS = Copy.Table(RHS, Flags, Cache)
			
			if Flags.Tables.Definition then
				setmetatable(LHS, Definition)
			end
		elseif Type == "function" and Flags.Functions then
			LHS = Copy.Function(RHS, Flags.Functions.Env, Flags.Functions.ShareUpvalues)
		else
			LHS = RHS
		end
		
		Cache[RHS] = LHS
	end

	return LHS
end

return Copy
