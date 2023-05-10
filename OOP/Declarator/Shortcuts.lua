local Module = require"Moonrise.Import.Module"
local Error = require"Moonrise.Tools.Error"
local Derive = require"Moonrise.OOP.Derive"

local Count = {}

---@class OOP.Declarator.Shortcuts
local Shortcuts = Module.Relative"Class.Factory"(
	Derive(
		"OOP.Declarator.Shortcuts", {
			Module.Sister"Definition"
		},
		{
			__newindex = function(Type, Key, Value)
				if Key == "Initialize" then
					Type.__initialize = Value
				elseif Key == "Parents" then
					Error.Caller.Throw"Can't override Parents field"
				elseif Key:sub(1,2) == "__" then
					rawset(Type, Key, Value)
				else
					Type.__members[Key] = Value
				end
			end;
			
			__index = function(Type, Key)
				if Key == "Initialize" then
					return Type.__initialize
				elseif Key == "Parents" then
					return Type.__parents
				elseif Key:sub(1,2) == "__" then
					Error.CallerError"Definition member not found"
				else
					--[[Count[Type.__type] = Count[Type.__type] or {}
					Count[Type.__type][Key] = (Count[Type.__type][Key] or 0) + 1
					print("Shortcuts", Type.__type, Key, Count[Type.__type][Key])]]
					return Type.__members[Key]
				end
			end;
		}
	)
)

return Shortcuts
