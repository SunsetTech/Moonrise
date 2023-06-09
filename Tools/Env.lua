local Package = {}

function Package.MakeOverlay(Overlay,Env)
	return setmetatable(
		Overlay,
		{
			__index = function(_,Key)
				return Env[Key]
			end,
			__newindex = function(_,Key,Value)
				Env[Key] = Value
			end
		}
	)
end

function Package.SetEnv(Function,Env)
	if _ENV then
		if (debug.getupvalue(Function,1) == "_ENV") then
			local function NonceFunction()
				return Env
			end
			debug.upvaluejoin(
				Function,1,
				NonceFunction,1
			)
		end
	elseif debug.setfenv then
		debug.setfenv(Function, Env)
	end
end

return Package


