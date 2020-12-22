local Function = require"Toolbox.Tools.Function"

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
			LHS = Function.Copy(RHS, Flags.Functions.Env, Flags.Functions.ShareUpvalues)
		else
			LHS = RHS
		end
		
		Cache[RHS] = LHS
	end

	return LHS
end

return Copy
