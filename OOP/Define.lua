local Module = require"Toolbox.Import.Module"

local Definition = Module.Sister"Declarator.Definition"
local Linker = Module.Sister"Class.Linker"
local Stash = Module.Sister"Class.Stash"

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
