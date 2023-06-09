local Utils = require"Moonrise.Import.Utils"
local DataStore = require"Moonrise.Import.DataStore"
local Indirection,Meta = Utils.From("Moonrise.Tools",{"Indirection","Meta"})

local Package = {}

function Package.Require(ModuleName)
	local ModuleData = DataStore.GetStore(ModuleName)
	if (ModuleData.Proxy) then
		return ModuleData.Proxy.Interface
	else
		local Success,ModuleOrError = pcall(require,ModuleName)
		if (Success) then
			local ModuleContainer, ModuleInterface = Indirection.CreateProxy() 
			ModuleData.Proxy = {
				Container = ModuleContainer,
				Interface = ModuleInterface,
			}
			ModuleData.Proxy.Container.Item = ModuleOrError
			return ModuleData.Proxy
		else
			Meta.CallerError(ModuleOrError)
		end
	end
end

return Package
