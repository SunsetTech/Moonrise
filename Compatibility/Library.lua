local Import = require"Toolbox.Import"
local Version = Import.Module.Sister"Version"

return {
	Length = function(RHS)
		if Version.Atleast(5,2) then
			return #RHS
		else
			local Metamethods = getmetatable(RHS)
			if Metamethods and Metamethods.__len then
				return Metamethods.__len(RHS)
			else
				return #RHS
			end
		end
	end;
}
