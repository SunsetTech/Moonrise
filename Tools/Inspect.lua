#!/bin/lua

local _type = type

local BasicTypes = {
	["function"] = {
		__eq = true,
		__call = true,
		__type = true
	},
	["string"] = {
		__eq = true,
		__len = true,
		__concat = true,
		__type = true
	},
	["nil"] = {
		__eq = true,
		__type = true
	},
	["number"] = {
		__eq = true,
		__lt = true,
		__le = true,
		__add = true,
		__sub = true,
		__mul = true,
		__div = true,
		__mod = true,
		__pow = true,
		__unm = true,
		__type = true
	},
	["table"] = {
		__eq = true,
		__index = true,
		__newindex = true,
		__len = true,
		__type = true
	},
	["boolean"] = {
		__eq = true,
		__type = true
	}
}

local Inspect = {
	Get = {};
	Basic = {};
	Error = {};
}

function Inspect.Get.Implements(Object, Metamethod)
	return (
		(getmetatable(Object) or {})[Metamethod] or
		(BasicTypes[_type(Object)] or {})[Metamethod]
	) ~= nil
end

function Inspect.Get.Type(Object)
	local Metatable = getmetatable(Object)
	
	if (Metatable and _type(Metatable) == "table" and Metatable.__type) then
		local Type = Metatable.__type
		
		if (_type(Type) == "function") then
			return Type(Object)
		else
			return Type
		end
	else
		return _type(Object)
	end
end

Inspect.GetType = Inspect.Get.Type

function Inspect.Basic.Type(Name)
	return BasicTypes[Name] ~= nil
end

function Inspect.Basic.Value(Object)
	return Inspect.Basic.Type(Inspect.Get.Type(Object))
end

function Inspect.Basic.Equivalent(Object, Name) --may not always be correct?
	assert(Inspect.Basic.Type(Name), "Argument 2 must be a base type")
	for Metamethod, _ in pairs(BasicTypes) do
		if (not Inspect.Lookup.Implements(Object, Metamethod)) then
			return false
		end
	end
	return true
end

function Inspect.Error.Throw(Types, Index, Type, Offset)
	error(
		([[Expected one of (%s) for argument %s, got '%s' instead"]]):format(
			table.concat(Types, ", "), tostring(Index), Type
		),
		Offset+1
	)
end

function Inspect.Error.Assert(Name, Object, Types)--??
	local ObjectType = Inspect.Get.Type(Object)
	for _, Type in pairs(Types) do
		if (Type == ObjectType) then
			return
		end
	end
	Inspect.Error.Throw(Types, Name, ObjectType)
	error(string.format([[Expected one of (%s) for '%s']],table.concat(Types,","),Name))
end

function Inspect.Error.Check(Parameters)
	return function(Arguments)
		for Index, ParameterTypes in pairs(Parameters) do
			local Argument = Arguments[Index]
			local ArgumentType = Inspect.GetType(Argument)
			
			local Valid = false
			for _, ParameterType in pairs(ParameterTypes) do
				if (ArgumentType == ParameterType) then
					Valid = true
					break
				else
					if (not Inspect.Basic.Type(ArgumentType) and Inspect.Basic.Type(ParameterType)) then
						if (Inspect.Basic.Equivalent(Argument, ParameterType)) then
							Valid = true
							break
						end
					end
				end
			end
			
			if (not Valid) then
				Inspect.Error.Throw(ParameterTypes, Index, ArgumentType)
			end
		end
	end
end


return Inspect
