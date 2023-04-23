local Tools = {
	Table = require"Moonrise.Tools.Table";
	String = require"Moonrise.Tools.String";
	Pretty = require"Moonrise.Tools.Pretty";
}
local OOP = require"Moonrise.OOP"

---@alias Adapt.Execution.Location string

---@class Bookmark
---@field At integer
---@field Variables table

---@class Adapt.Execution.State
---@operator call(): Adapt.Execution.State 
---@field public Buffer Adapt.Stream.Base
---@field public Debug boolean
---@field private Variables table
---@field private IsInVariableNames table
---@field private VariableNames string[]
---@field public RaiseCache table
---@field public NameMap table
---@field public JumpMap table
local State = OOP.Declarator.Shortcuts"Moonrise.Adapt.Execution.State"

---@param Instance Adapt.Execution.State
---@param Buffer Adapt.Stream.Base
function State:Initialize(Instance, Buffer, Debug) --TODO registers
	Instance.Buffer = Buffer
	
	Instance.Variables = {}
	Instance.IsInVariableNames = {}
	Instance.VariableNames = {}
	
	Instance.JumpMap = {}
	Instance.NameMap = {}
	Instance.RaiseCache = {}
	
	Instance.Debug = Debug or false
end

---@param Node Adapt.Transform.Base
---@param SubPath table<integer, string>
local function ForwardSearch(Node, SubPath)
	local CurrentNode = Node
	for Index = 1,#SubPath do
		local Part = SubPath[Index]
		---@cast CurrentNode Adapt.Transform.Compound
		if CurrentNode.Children and CurrentNode.Children[Part] then
			CurrentNode = CurrentNode.Children[Part]
		else
			return
		end
	end
	return CurrentNode
end

local function BackwardSearch(Stack, SubPath)
	for Index = #Stack, 1, -1 do
		local Haystack = Stack[Index]
		--print("Searching for ".. table.concat(SubPath, ".") .." in ".. tostring(Haystack))
		local Needle = ForwardSearch(Haystack, SubPath)
		if Needle then
			return Needle
		end
	end
end

function State:Link(Node, At, Stack)
	Stack = Stack or {Node}
	At = At or {"Root"}
	local Path = table.concat(At,".")
	if self.NameMap[Node] == Path then
		print"Reusing links"
		return --Already linked beyond here
	end
	self.NameMap[Node] = Path
	if Node.Children then
		for Name, Child in pairs(Node.Children) do
			Tools.Table.PushLast(At, Name)
			Tools.Table.PushLast(Stack, Child)
				self:Link(Child, At, Stack)
				if OOP.Reflection.Type.Name(Child) == "Adapt.Transform.Jump" then
					---@cast Child Adapt.Transform.Jump
					local SubPath = Tools.String.Explode(Child.SubPath,".")
					local Needle = BackwardSearch(Stack, SubPath)
					assert(Needle, "Didn't find jump target ".. Child.SubPath .." for ".. table.concat(At, "."))
					self.JumpMap[Child] = Needle
				end
			Tools.Table.PopLast(Stack)
			Tools.Table.PopLast(At)
		end
	end
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

function State:Position()
	return self.Buffer:At()
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
	self.Link = State.Link
end

return State
