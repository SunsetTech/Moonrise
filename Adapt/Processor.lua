local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Bubble = Module.Sister"Bubble"

local Processor = OOP.Declarator.Shortcuts"Adapt.Processor"

function Processor:Initialize(Instance, Buffer, Root)
	Instance.Buffer = Buffer
	
	Instance.Stack = {
		{
			Name = "Root";
			Rule = Root;
		}
	}
end

function Processor:State()
	return self.Stack[#self.Stack]
end

function Processor:Push(Name)
	local Rule = self:State().Rule.Children[Name]
	
	table.insert(
		self.Stack, {
			Name = Name;
			Rule = Rule;
		}
	)
	
	return Rule
end

function Processor:Pop(Name)
	local State = table.remove(self.Stack, #self.Stack)
	
	assert(State.Name == Name)
end

function Processor:Mark()
	local Bookmark = {
		State = self:State();
		At = self.Buffer:At();
	}
	
	return Bookmark
end

function Processor:Rewind(Bookmark)
	assert(self:State() == Bookmark.State)
	
	self.Buffer:Goto(Bookmark.At)
end

function Processor:Read(Bytes)
	return self.Buffer:Read(Bytes)
end

function Processor:Write(String)
	return self.Buffer:Write(String)
end

function Processor:Fork(Mode, Name, Argument)
	local Success, Result
	
	do local Rule = self:Push(Name)
		if Mode == "Left" then
			Success, Result = Bubble.Form(
				Rule:Left(self, Bubble.Pop(Argument))
			)
		elseif Mode == "Right" then
			Success, Result = Bubble.Form(
				Rule:Right(self, Bubble.Pop(Argument))
			)
		end
	end self:Pop(Name)
	
	return Success, Bubble.Pop(Result)
end

function Processor:Right(Name, Argument)
	return self:Fork("Right", Name, Argument)
end

function Processor:Left(Name, Argument)
	return self:Fork("Left", Name, Argument)
end


return Processor
