local Functional = {}

function Functional.Packer(Keys)
	return function(...)
		local Values = {...}
		local Result = {}
		
		for Index, Key in pairs(Keys) do
			Result[Key] = Values[Index]
		end
		
		return Result
	end
end

function Functional.Return(...)
	return ...
end

function Functional.Blank()
end

return Functional
