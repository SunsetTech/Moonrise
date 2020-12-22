return function(Definition, Initializer)
	local Instance = Initializer or {}
	local ID = tostring(Instance)
	setmetatable(Instance, Definition)
	return Instance, ID
end
