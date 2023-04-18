local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.Compound : Adapt.Transform.Base
---@operator call(): Adapt.Transform.Compound
---@field Children table<any, Adapt.Transform.Base>
local Compound = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Compound", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

---@param Instance Adapt.Transform.Compound
---@param Children table<any, Adapt.Transform.Base>
function Compound:Initialize(Instance, Children)
	Instance.Children = Children or {}
end

function Compound:Optimize()
	Compound.Parents.Base.Optimize(self)
	if not self.Children then print"???" end
	for _, Child in pairs(self.Children or {}) do ---who?
		Child:Optimize()
	end
end

return Compound
