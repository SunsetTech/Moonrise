local OOP = require"Moonrise.OOP"

---@class Adapt.Execution.Location
---@operator call:Adapt.Execution.Location
---@field Name string
---@field Node Adapt.Transform.Base
---@field Parent Adapt.Execution.Location
---@field History table<integer, Adapt.Execution.Location>
local Location = OOP.Declarator.Shortcuts"Adapt.Execution.Location"

---@param Name string
---@param Node Adapt.Execution.Location
---@param Parent Adapt.Execution.Location
function Location:Initialize(Instance, Name, Node, Parent)
	Instance.Name=Name
	assert(type(Name)=="string")
	Instance.Node=Node
	Instance.Parent = Parent
	Instance.History = {}
end

function Location:PushLocation(Where)
	table.insert(self.History, Where)
end

---@param Name string
---@param Node Adapt.Execution.Location
function Location:Push(Name, Node)
	local Child = Location(Name, Node, self)
	self:PushLocation(Child)
	return Child
end

---@param Child Adapt.Execution.Location
function Location:Pop(Child)
	---@type Adapt.Execution.Location
	local Popped = table.remove(self.History)
	assert(Child and Popped == Child)
end

---@return Adapt.Execution.Location
function Location:GetLatest()
	return self.History[#self.History]
end

function Location:HasLatest()
	return self:GetLatest() ~= nil
end

---@return Adapt.Execution.Location
function Location:GetHead()
	if self:GetLatest() then
		return self:GetLatest():GetHead()
	else
		return self
	end
end

---@return string
function Location:ToPath(Debug)
	local Latest = self:GetLatest()
	return self.Name .. (Debug and ("(".. tostring(self.Node) ..")") or "") .. (Latest and (".".. Latest:ToPath(Debug)) or "")
end

return Location
