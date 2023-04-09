local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Parent = OOP.Declarator.Shortcuts(
	"Adapt.Element.Parent", {
		Module.Sister"Base"
	}
)

function Parent:Initialize(Instance, Children)
	Instance.Children = Children or {}
end

return Parent
