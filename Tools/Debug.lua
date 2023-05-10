local IndentLevel = 0
local Debug; Debug = {
	Push = function()
		IndentLevel = IndentLevel + 1
	end;

	---@vararg any
	Print = function(...)
		local Parts = {...}
		for Index = 1, select("#",...) do
			Parts[Index] = tostring(Parts[Index])
		end
		print(string.rep("  ", IndentLevel) .. table.concat(Parts,"\t"))
	end;
	
	---@param FormatString string
	---@return fun(...:any)
	Format = function(FormatString)
		return function(...)
			Debug.Print(FormatString:format(...))
		end
	end;
	
	Pop = function(...)
		IndentLevel = IndentLevel - 1
	end;
	
	GetCaller = function(Offset)
		Offset = Offset or 0
		local Info = debug.getinfo(3+Offset, "Sl")
		if Info then
			return Info.short_src, Info.currentline
		end
	end;
	
	PrintCaller = function(Offset)
		Offset = Offset or 0
		local Source, Line = Debug.GetCaller(Offset+1)
		if Source then
			Debug.Format"Called from file %s at line %d"(Source, Line)
		else
			Debug.Print"Could not get caller information."
		end
	end;

	PrintStack = function()
		local level = 2 -- Start from the level above the current function
		while true do
			local info = debug.getinfo(level, "Sln")
			if not info then break end -- Stop when there's no more information

			local src = info.source or "[unknown]"
			local line = info.currentline or -1
			local func_name = info.name or "[unknown]"
			print(string.format("Level %d: %s:%d (%s)", level - 1, src, line, func_name))

			level = level + 1
		end
	end
}; return Debug;

