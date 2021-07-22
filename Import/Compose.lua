local Utils = require"Moonrise.Import.Utils"

local Function, Env = Utils.From("Moonrise.Tools",{"Function","Env"})

local Package = {}

function Package.Override(Require,OverrideRequire)
	local NewEnv = Env.MakeOverlay(
		{require=OverrideRequire},
		_ENV or debug.getfenv(debug.getinfo(0,"f").func) 
	)
	return Function.Copy(Require,NewEnv,true)
end

local OldRequire = require

local function DefaultRequire(...)
	return OldRequire(...)
end

function Package.Pipeline(Functions,InnerRequire)
	--Create a copy of require to ensure the env is the current env
	InnerRequire = InnerRequire or DefaultRequire
	local Pipeline = Function.Copy(
		InnerRequire,
		_ENV or debug.getfenv(debug.getinfo(0,"f").func),
		true)
	
	for Index = 1, #Functions do
		Pipeline = Package.Override(Functions[Index],Pipeline)
	end
	return Pipeline
end

return Package
