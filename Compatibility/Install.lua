local Version = require"Toolbox.Compatibility.Version"
local Installed = false

return function()
	if not Installed then
		if not Version.Atleast(5,3) then
			table.unpack = unpack
			
			local _pairs = pairs
			pairs = function(Table)
				local Definition = getmetatable(Table)
				if Definition and Definition.__pairs then
					return Definition.__pairs(Table)
				else
					return _pairs(Table)
				end
			end
		end
		Installed = true
	end
end
