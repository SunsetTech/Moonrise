local Pretty; Pretty = { --TODO this could be an Adapt grammar
	String = function(Contents)
		return ([["%s"]]):format(Contents)
	end;
	
	---@param Source table
	---@param IndentPerLevel integer | nil
	---@param Multiline boolean | nil 
	---@param IndentAmount integer | nil
	---@param SeenCache table<table, boolean> | nil
	---@return string
	Table = function(Source, Multiline, IndentPerLevel, IndentAmount, SeenCache)
		IndentAmount = IndentAmount or 0
		IndentPerLevel = IndentPerLevel or 0
		SeenCache = SeenCache or {}
		Multiline = Multiline or false
		local EndChar = Multiline and "\n" or ""
		if SeenCache[Source] then
			return tostring(Source)
		else
			SeenCache[Source] = true
			IndentAmount = IndentAmount + IndentPerLevel
			local Parts = {}
			for Key, Value in pairs(Source) do
				Key = "["..Pretty.Any(Key, Multiline, IndentPerLevel, IndentAmount, SeenCache).."]"
				Value = Pretty.Any(Value, Multiline, IndentPerLevel, IndentAmount, SeenCache)
				table.insert(Parts, ([[%s%s = %s]]):format(string.rep(" ",IndentAmount), Key, Value))
			end
			IndentAmount = IndentAmount - IndentPerLevel
			return "{".. EndChar .. table.concat(Parts, ", ".. EndChar) .. EndChar .. string.rep(" ", IndentAmount) .."}"
		end
	end;

	---@param Value any
	---@param Multiline boolean?
	---@param IndentPerLevel integer?
	---@param IndentAmount integer?
	---@param SeenCache table<table, boolean>?
	---@return string
	Any = function(Value, Multiline, IndentPerLevel, IndentAmount, SeenCache)
		local Type = type(Value)
		if Type == "table" then return Pretty.Table(Value, Multiline, IndentPerLevel, IndentAmount, SeenCache)
		elseif Type == "string" then return Pretty.String(Value) 
		else return tostring(Value) end
	end;
}; return Pretty
