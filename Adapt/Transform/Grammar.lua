local String = require"Moonrise.Tools.String"
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Grammar : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Grammar
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
	return Execution.Recurse(CurrentState, "Raise", self.Children[1], Argument)
end

function Grammar:Lower(CurrentState, Argument)
	return Execution.Recurse(CurrentState, "Lower", self.Children[1], Argument)
end

function Grammar:__tostring()
	local Parts = {}
	for Key, Child in pairs(self.Children) do
		table.insert(Parts, Key ..": ".. tostring(Child))
	end
	return
		"Grammar<\n".. String.Indent(table.concat(Parts, ", \n"),1,"  ") .."\n>"
end

return Grammar

