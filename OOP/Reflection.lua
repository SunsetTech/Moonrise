local Reflection; Reflection = {
	Type = {
		Name = function(Object)
			local Meta = getmetatable(Object)
			return Meta and Meta.__type or type(Object)
		end;
		
		Of = function(Class, Object)
			local Meta = getmetatable(Object)
			--print(Meta, Class)
			if Meta and Meta.__implements then
				return Meta:__implements(Class)
			else
				return false
			end
		end;
	};
}; return Reflection
