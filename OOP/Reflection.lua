local Reflection; Reflection = {
	Type = {
		Name = function(Object)
			local Meta = getmetatable(Object)
			return Meta and Meta.__type or type(Object)
		end;
		
		Of = function(Class, Object)
			local Meta = getmetatable(Object)
			if Meta and Meta.__typeof then
				return Meta:__typeof(Class)
			else
				return false
			end
		end;
	};
}; return Reflection
