local Module = require"Moonrise.Import.Module"

local Definition = require"Moonrise.OOP.Declarator.Definition"
local Linker = require"Moonrise.OOP.Class.Linker"
local Stash = require"Moonrise.OOP.Class.Stash"

return function(Name, Inherits, Static, Dynamic, Types)
	Types = {
		Declarator = Types.Declarator or Definition;
		Linker = Types.Linker or Linker;
		Stash = Types.Stash or Stash;
	}
	
	local Derived = Types.Declarator(Name, Inherits, Static, Dynamic, Types.Linker)
	
	return 
		Derived, 
		Derived.__members, Types.Stash(Derived),
		Derived.__parents, table.unpack(Derived.__inherits)
end
