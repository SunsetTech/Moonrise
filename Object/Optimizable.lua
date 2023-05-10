local OOP = require"Moonrise.OOP"

local Optimizable = OOP.Declarator.Shortcuts"Moonrise.Object.Optimizable"

local function Optimize(From, Into)
	for _, Inherit in pairs(From.__inherits) do
		Optimize(Inherit, Into)
	end
	for Key, Member in pairs(From.__members or {}) do
		Into[Key] = Member
	end
end

function Optimizable:Optimize()
	local Type = getmetatable(self)
	Optimize(Type, self)
end

return Optimizable
