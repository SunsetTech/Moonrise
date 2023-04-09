local Tools = require"Moonrise.Tools"

--- @param Name string
--- @param Inherits table
--- @param Static table
--- @param Dynamic table
--- @param Linker fun(static: table, dynamic: table): table
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
	Static.__link = Linker and Linker(Static, Dynamic) or Tools.Functional.Return
	
	for Name, Member in pairs(Static:__link{}) do
		Static[Name] = Static[Name] or Member
	end
	
	for _, Inherit in pairs(Inherits) do
		local Members = Tools.Table.Merge(
			{}, 
			Inherit,
			Inherit.__link(Static, {})
		)
		for Key, Member in pairs(Members) do 
			if Static.__link ~= Tools.Functional.Return and Inherit.__link ~= Tools.Functional.Return then
				Static.__link.Generators[Key] = Static.__link.Generators[Key] or Inherit.__link.Generators[Key]
			end
			Static[Key] = Static[Key] or Member
		end
	end
	
	return Static
end
