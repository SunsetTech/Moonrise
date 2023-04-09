--- @param Definition table
--- @param Initializer table
--- @return table, string
local function Create(Definition, Initializer)
	local Instance = Initializer or {}
	local ID = tostring(Instance)
	setmetatable(Instance, Definition)
	return Instance, ID
end

return Create
