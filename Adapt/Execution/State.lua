local OOP = require"Moonrise.OOP"

local Location = require"Moonrise.Adapt.Execution.Location"

---@class Bookmark
---@field At integer

---@class Adapt.Execution.State
---@operator call(): Adapt.Execution.State 
---@field public RootLocation Adapt.Execution.Location
---@field private Buffer Adapt.Stream.Base
local State = OOP.Declarator.Shortcuts"Moonrise.Adapt.Execution.State"

---@param Buffer Adapt.Stream.Base
function State:Initialize(Instance, Buffer) --TODO registers
	Instance.Buffer = Buffer
end

---@param Name string
---@param Node Adapt.Execution.Location
---@return Adapt.Execution.Location #the location for the pushed
function State:AppendLocation(Name, Node)
	if self.RootLocation == nil then
		self.RootLocation = Location(Name, Node)
		return self.RootLocation
	else
		local Head = self.RootLocation:GetHead()
		Head:Push(Name, Node)
		return Head:GetLatest()
	end
end

--[[
---@param Node Adapt.Execution.Location
function State:PopChildLocation(Node)
	self.RootLocation:GetHead():Pop(Node)
end]]

---@return Bookmark
function State:Mark() --TODO copy of registers
	local Bookmark = {
		At = self.Buffer:At();
	}
	
	return Bookmark
end

---@param Bookmark Bookmark
function State:Rewind(Bookmark)
	self.Buffer:Goto(Bookmark.At)
end

---@param Count integer
---@return string
function State:Read(Count)
	return self.Buffer:Read(Count)
end

---@param String string
---@return integer
function State:Write(String)
	return self.Buffer:Write(String)
end

return State
