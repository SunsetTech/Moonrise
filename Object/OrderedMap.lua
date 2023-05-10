local OOP = require"Moonrise.OOP"
local Tools = require"Moonrise.Tools"
---@class Moonrise.Object.OrderedMap
---@operator call:Moonrise.Object.OrderedMap
---@field Pairs table<string,any>
---@field Keys table<integer,string>
---@field Present table<string, boolean>
local OrderedMap = OOP.Declarator.Shortcuts"Moonrise.Object.OrderedMap"

local Count = 0

---@param Key string
---@param Value any
function Add(self, Key, Value)
	--print(not self.Present[Key] and "Is this an error?" or "")
	if self.Present[Key] then
		self:Set(Key, Value)
	else
		self.Pairs[Key] = Value
		table.insert(self.Keys, Key)
		self.Present[Key] = true
	end
end OrderedMap.Add = Add

function GetPair(self,N)
	local Key = self.Keys[N]
	local Value = self.Pairs[Key]
	return Key, Value
end OrderedMap.GetPair = GetPair


---@param Key string
---@param Value any
local function Set(self, Key, Value)
	assert(self.Present[Key])
	self.Pairs[Key] = Value
end OrderedMap.Set = Set

---@param Key string
---@return any
local function Get(self, Key)
	return self.Pairs[Key]
end OrderedMap.Get = Get

---@return integer
local function NumKeys(self)
	return #self.Keys
end OrderedMap.NumKeys = NumKeys

local function Remove(self, Key)
	error"NYI"
end

---@param Instance Moonrise.Object.OrderedMap
---@param Pairs table<string, any>
function OrderedMap:Initialize(Instance, Pairs)
	--if Pairs then Tools.Debug.PrintStack() end
	Instance.Pairs = Pairs or {}
	Instance.Keys = {}
	Instance.Present = {}
	if Pairs then
		Instance.Pairs = Pairs
		for Key in pairs(Pairs) do
			table.insert(Instance.Keys, Key)
			Instance.Present[Key] = true
		end
	else
		Instance.Pairs = {}
	end
	Instance.Add = Add
	Instance.Set = Set
	Instance.Get = Get
	Instance.NumKeys = NumKeys
	Instance.GetPair = GetPair
end

return OrderedMap
