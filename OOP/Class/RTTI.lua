local Module = require"Moonrise.Import.Module"

local Derive = Module.Relative"Derive"

return Derive(
	"OOP.Class.RTTI", 
	nil,
	{
		__implements = function(self, Type)
			local ArgType = type(Type)
			
			local SelfID =
				ArgType == "table" and self 
				or (
					ArgType == "string" and self.__type
					or nil
				)
			
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
		end;
		
		__typeof = function(self, Type)
			return getmetatable(self):__implements(Type)
		end;
	}
)
