local Module = require"Moonrise.Import.Module"
local Path = require"Moonrise.Import.Path"
local Compose = require"Moonrise.Import.Compose"

local Package = {}

local ModuleSystemsInstalled = false
function Package.ModuleSystems()
	if not ModuleSystemsInstalled then
		if PathSystemsInstalled then
			Package.All()
		else
			require = Module.Require
		end
		ModuleSystemsInstalled = true
	end
end

local PathSystemsInstalled = false
function Package.PathSystems()
	if not PathSystemsInstalled then
		if ModuleSystemsInstalled then
			Package.All()
		else
			require = Path.Require
		end
		PathSystemsInstalled = true
	end
end

function Package.All()
	if not ModuleSystemsInstalled or not PathSystemsInstalled then
		require = Compose.Pipeline{Path.Require,Module.Expose} 
	end
end

Package.All()

return Package
