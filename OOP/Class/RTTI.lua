local Module = require"Moonrise.Import.Module"

local Derive = Module.Relative"Derive"

--- @param Type string|table
--- @return boolean
local function __implements(self, Type)
	local ArgType = type(Type)
	
	local SelfID =
		ArgType == "table" and self 
		or (
			ArgType == "string" and self.__type
			or nil
		)
	
	--print(self, ArgType, SelfID, Type)
	if SelfID == Type then 
		return true
	else
		for InheritIndex = 1, #self.__inherits do
			local Inherit = self.__inherits[InheritIndex]
			if Inherit:__implements(Type) then
				return true
			end
		end
	end
	
	return false
end

--- @param Type string|table
--- @return boolean
local function __typeof(self, Type)
	return getmetatable(self):__implements(Type)
end

return Derive(
	"OOP.Class.RTTI", 
	nil,
	{
		__implements = __implements,
		--__typeof = __typeof
	}
)

