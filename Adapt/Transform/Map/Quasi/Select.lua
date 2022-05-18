local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Bubble = Module.Relative"Bubble"

local Select = OOP.Declarator.Shortcuts(
	"Adapt.Element.Select", {
		Module.Sister"Compound"
	}
)

function Select:Initialize(Instance, Children)
	Instance.Children = Children or {}
end

function Select:Split(Processor, ...) --From stream
	local Bookmark = Processor:Mark()
	
	for Name in pairs(self.Children) do
		local Success, Result = Bubble.Form(
			Processor:Decompile(Name, Argument)
		)
		
		if not Success then
			Processor:Rewind(Bookmark)
		else
			return Success, Bubble.Pop(Result)
		end
	end
end

function Select:Fuse(Processor, Argument) --To stream
	local Bookmark = Processor:Mark()
	
	for Name in pairs(self.Children) do
		local Success, Result = Bubble.Form(Processor:Compile(Name, Argument))
		
		if not Success then
			Processor:Rewind(Bookmark)
		else
			return Success, Bubble.Pop(Result)
		end
	end
end

return Select
