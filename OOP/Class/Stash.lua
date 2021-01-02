local Module = require"Moonrise.Import.Module"

local function NewTable()
	return {}
end

local InitializeEntry = {}
return Module.Relative"Declarator.Definition"(
	"OOP.Class.Stash", {
		Module.Sister"Constructor"
	}, 
	{
		__mode = "k";
		
		__index = function(Instance, Context)
			Instance[Context] = InitializeEntry[Instance]()
			
			return Value
		end;
		
		__initialize = function(self, Instance, Initializer)
			InitializeEntry[Instance] = Initializer or NewTable()
		end;
	}
)
