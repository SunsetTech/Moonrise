local Utils = require"Moonrise.Import.Utils"
local Path,Module = Utils.From("Moonrise.Tools",{"Path","Module"})

local Package = {}

local ModuleData = {}

function Package.GetStore(ModuleName)
	print(ModuleName, Module.Locate(ModuleName))
	local Key = Path.RealPath(Module.Locate(ModuleName))
	ModuleData[Key] = ModuleData[Key] or {}
	return ModuleData[Key]
end

return Package
