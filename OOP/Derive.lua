local Tools ={
	Table = require"Moonrise.Tools.Table";
	Copy = require"Moonrise.Tools.Copy";
}
local Functional = require"Moonrise.Functional"

--- @param Name string
--- @param Inherits table
--- @param Static table|nil
--- @param Dynamic table|nil
--- @param Linker (fun(static: table, dynamic: table|nil): table)|nil
--- @return table
return function(Name, Inherits, Static, Dynamic, Linker)
	--[[Note: Precedence
		1. Members defined in Static
		2. Members generated from Dynamic
		3. Members generated from Inherit.__link
		4. Members defined in Inherit
	]]

	Static = Static and Tools.Copy.Value(Static) or {}
	Inherits = Inherits or {}
	
	Static.__type = Name
	Static.__inherits = Inherits or {}
	Static.__link = Linker and Linker(Static, Dynamic) or Functional.Basic.Return
	
	for _Name, Member in pairs(Static:__link{}) do
		Static[_Name] = Static[_Name] or Member
	end
	
	for _, Inherit in pairs(Inherits) do
		local Members = Tools.Table.Merge(
			{}, 
			Inherit,
			Inherit.__link(Static, {})
		)
		for Key, Member in pairs(Members) do 
			if Static.__link ~= Functional.Basic.Return and Inherit.__link ~= Functional.Basic.Return then
				Static.__link.Generators[Key] = Static.__link.Generators[Key] or Inherit.__link.Generators[Key]
			end
			Static[Key] = Static[Key] or Member
		end
	end
	
	return Static
end
