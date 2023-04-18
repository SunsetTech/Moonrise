local OOP = require"Moonrise.OOP"
local Location = require"Moonrise.Adapt.Execution.Location"
local LocationAllocator = require"Moonrise.Adapt.Optimization.LocationAllocator"

---@class Bookmark
---@field At integer
---@field Variables table

---@class Adapt.Execution.State
---@operator call(): Adapt.Execution.State 
---@field public RootLocation Adapt.Execution.Location
---@field public Buffer Adapt.Stream.Base
---@field public Debug boolean
---@field private Variables table
---@field private IsInVariableNames table
---@field private VariableNames string[]
---@field public JumpCache table
---@field public RaiseCache table
local State = OOP.Declarator.Shortcuts"Moonrise.Adapt.Execution.State"

---@param Instance Adapt.Execution.State
---@param Buffer Adapt.Stream.Base
function State:Initialize(Instance, Buffer, Debug) --TODO registers
	Instance.Buffer = Buffer
	Instance.Debug = Debug or false
	Instance.Variables = {}
	Instance.IsInVariableNames = {}
	Instance.VariableNames = {}
	Instance.JumpCache = {}
	Instance.RaiseCache = {}
end

---comment
---@param Key string
---@param Value any
function State:SetVariable(Key, Value)
	if not self.IsInVariableNames[Key] then
		self.IsInVariableNames[Key] = true
		table.insert(self.VariableNames, Key)
	end
	self.Variables[Key] = Value
end

---comment
---@param Key string
---@return any
function State:GetVariable(Key)
	return self.Variables[Key]
end

---@param Name string
---@param Node Adapt.Transform.Base
---@return Adapt.Execution.Location #the location for the pushed
function State:AppendLocation(Name, Node)
	if self.RootLocation == nil then
		self.RootLocation = LocationAllocator.Allocate(Name, Node)
		return self.RootLocation
	else
		local Head = self.RootLocation:GetHead()
		Head:Push(Name, Node)
		return Head:GetLatest()
	end
end

---@return string
function State:GetPath()
	return self.RootLocation and self.RootLocation:ToPath() or ""
end

--[[
---@param Node Adapt.Execution.Location
function State:PopChildLocation(Node)
	self.RootLocation:GetHead():Pop(Node)
end]]

function State:CopyVariables()
	local Copy = {}
	--for Key, Value in pairs(self.Variables) do
	for i = 1, #self.VariableNames do
		local Key = self.VariableNames[i]
		local Value = self.Variables[Key]
		Copy[Key]=Value
	end
	return Copy
end

---@return Bookmark
function State:Mark() --TODO copy of registers
	--Allocation.Increment"Bookmarks"
	--local Bookmark = Allocation.Grab"Bookmarks"
	local Bookmark = {
		Variables = self:CopyVariables();
		At = self.Buffer:At();
	}
	return Bookmark
end

function State:RestoreVariables(Variables)
	self.Variables = {}
	for i = 1, #self.VariableNames do
		local Key = self.VariableNames[i]
		local Value = Variables[Key]

		self.Variables[Key]=Value
	end
end

---@param Bookmark Bookmark
function State:Rewind(Bookmark)
	self.Buffer:Goto(Bookmark.At)
	self:RestoreVariables(Bookmark.Variables)
end

function State:ClearMark(Bookmark)
end

---@param Count integer
---@return string
function State:Read(Count)
	return self.Buffer:Read(Count)
end

function State:Peek(Count)
	local Bookmark = self:Mark()
		local Contents = self:Read(Count)
	self:Rewind(Bookmark)
	return Contents
end

---@param String string
function State:Write(String)
	self.Buffer:Write(String)
end

function State:Optimize()
	self.Write = State.Write
	self.Read = State.Read
	self.Peek = State.Peek
	self.Rewind = State.Rewind
	self.Mark = State.Mark
	self.CopyVariables = State.CopyVariables
	self.RestoreVariables = State.RestoreVariables
	self.ClearMark = State.ClearMark
	self.AppendLocation = State.AppendLocation
end

return State
