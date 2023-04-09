
local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Frame = require"Moonrise.Adapt.Execution.Frame"
local State = OOP.Declarator.Shortcuts"Moonrise.Adapt.Execution.State"

function State:Initialize(Instance, Buffer )
	Instance.Buffer = Buffer
	Instance.Stack = {}
end

function State:Top() --Get top of stack
	return self.Stack[#self.Stack]
end

function State:Push(Name, Node)
	table.insert(
		self.Stack, 
		Frame(Name, Node)
	)
end

function State:Pop(Name)
	local CurrentFrame = table.remove(self.Stack, #self.Stack)
	assert(CurrentFrame.Name == Name)
end


function State:Mark() --need to check the logic of these two
	local Bookmark = {
		State = self:Top();
		At = self.Buffer:At();
	}
	
	return Bookmark
end

function State:Rewind(Bookmark)
	assert(self:Top() == Bookmark.State)
	
	self.Buffer:Goto(Bookmark.At)
end

function State:Read(Bytes)
	return self.Buffer:Read(Bytes)
end

function State:Write(String)
	return self.Buffer:Write(String)
end

return State
