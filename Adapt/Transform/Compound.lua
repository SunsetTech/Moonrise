local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Compound = OOP.Declarator.Shortcuts(
	"Adapt.Element.Compound", {
		Module.Sister"Base"
	}
)

function Compound:Initialize(Instance, Children)
	Instance.Children = Children or {}
end

return Compound
