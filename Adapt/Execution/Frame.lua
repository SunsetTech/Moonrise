
---@class Frame
---@field public Name string
---@field public Node table
---@field public Initialize fun(self: Frame, Instance: table, Name: string, Node: table): nil
---@operator call(string): Frame
local OOP = require"Moonrise.OOP"

---@type Frame
local Frame = OOP.Declarator.Shortcuts("Adapt.Execution.Frame")

---@param Instance table
---@param Name string
---@param Node table
function Frame:Initialize(Instance, Name, Node)
    Instance.Name = Name
    Instance.Node = Node
end

return Frame

