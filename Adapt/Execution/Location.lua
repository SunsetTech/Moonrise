local OOP = require"Moonrise.OOP"

local _LocationAllocator
function LocationAllocator()
	_LocationAllocator = _LocationAllocator or require"Moonrise.Adapt.Optimization.LocationAllocator"
	return _LocationAllocator
end

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
	LocationAllocator().Harf()
	Instance.Name=Name
	assert(type(Name)=="string" or print(Name))
	Instance.Node=Node
	Instance.Parent = Parent
	Instance.History = {}
	Instance:Optimize()
end

function Location:Optimize()
	self.PushLocation = Location.PushLocation
	self.Push = Location.Push
	self.Pop = Location.Pop
	self.GetHead = Location.GetHead
	self.ToPath = Location.ToPath
	self.GetLatest = Location.GetLatest
end

function Location:PushLocation(Where)
	table.insert(self.History, Where)
end


---@param Name string
---@param Node Adapt.Transform.Base
function Location:Push(Name, Node)
	local Child = LocationAllocator().Allocate(Name, Node, self)
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

function Location:ToPathFromParent()
	if self.Parent then
		return self.Parent:ToPathFromParent() ..".".. self.Name
	else
		return self.Name
	end
end

return Location
