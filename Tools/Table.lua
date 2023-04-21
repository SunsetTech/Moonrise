local Table = {}

function Table.FindFirst(Source,What)
	for Key,Value in pairs(Source) do
		if (Value == What) then
			return Key
		end
	end
end

function Table.Keys(Source)
	local Results = {}
	for Key,_ in pairs(Source) do
		table.insert(Results,Key)
	end
	return Results
end

function Table.Values(Source)
	local Results = {}
	for _,Value in pairs(Source) do
		table.insert(Results,Value)
	end
	return Results
end

function Table.Apply(Modifier, Source, Into)
	Into = Into or {}
	for Key, Value in pairs(Source) do
		local r = Modifier(Value)
		Into[Key] = r
	end
	return Into
end

function Table.ForEach(Source,Function)
	for Key,Value in pairs(Source) do
		Function(Source,Key,Value)
	end
end

function Table.CachedCopy(Cache,Value,IncludeMetatable)
	if (not Cache[Value]) then
		Cache[Value] = {}
		Table.Copy(Value,IncludeMetatable,Cache,Cache[Value])
	end
	return Cache[Value]
end

function Table.Copy(Source,IncludeMetatable,Cache,Target)
	IncludeMetatable = IncludeMetatable or true
	Cache = Cache or {}
	Target = Target or {}
	for Key,Value in pairs(Source) do
		if (type(Key) == "table") then
			Key = Table.CachedCopy(Cache,Key,IncludeMetatable)
		end
		if (type(Value) == "table") then
			Value = Table.CachedCopy(Cache,Value,IncludeMetatable)
		end
		Target[Key] = Value
	end
	if (IncludeMetatable) then
		setmetatable(Target,getmetatable(Source))
	end
	return Target
end

Table.SimpleCopy = Table.Copy

function Table.Replace(SourceA,SourceB)
	local NewSource = {}
	for Key,_ in pairs(SourceA) do
		NewSource[Key] = SourceB[Key] or SourceA[Key]
	end
	return NewSource
end

function Table.Merge(Into, ...)
	local Sources = {...}
	for _, Source in pairs(Sources) do
		for Key,Value in pairs(Source) do
			Into[Key] = Value
		end
	end
	return Into
end

function Table.Concat(Combiner,Items)
	print(Combiner,Items)
	local Current = Items[1]
	for Index = 2, #Items do
		Current = Combiner(Current,Items[Index])
	end
	return Current
end

function Table.PushLast(Into, Item)
	table.insert(Into, Item)
end

function Table.PopLast(From)
	return table.remove(From, #From)
end

return Table
