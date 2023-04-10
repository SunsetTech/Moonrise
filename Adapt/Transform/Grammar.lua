
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Grammar : Adapt.Transform.Compound
Grammar = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Grammar", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Grammar:Initialize(Instance, Children)
---@diagnostic disable-next-line:undefined-field
		Grammar.Parents.Compound:Initialize(Instance, Children)
end

function Grammar:Raise(CurrentState, Argument) --Root
	return Execution.Recurse(CurrentState, "Raise", "Root", self.Children[1], Argument)
end

function Grammar:Lower(CurrentState, Argument)
	return Execution.Recurse(CurrentState, "Lower", "Root", self.Children[1], Argument)
end

return Grammar
