local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Bubble = Module.Relative"Bubble"

local Sequence = OOP.Declarator.Shortcuts(
	"Adapt.Element.Sequence", {
		Module.Sister"Compound"
	}
)

--TODO change element methods to Split/Join ?
function Sequence:Split(Processor, Arguments) --map of arguments/bubbles to slots
	Arguments = Arguments or {}
	local Results = {}
	
	for Name in pairs(self.Children) do
		local Argument = Arguments[Name]
		
		local Success, Result = Bubble.Form(
			Processor:Decompile(Name, Argument)
		)
		
		if Success then
			table.insert(Results, Result)
		else
			return false
		end
	end
	
	return true, table.unpack(Results)
end

function Sequence:Fuse(Processor, Arguments)
	Arguments = Arguments or {}
	local Results = {}
	
	for Name in pairs(self.Children) do
		local Argument = Arguments[Name]
		
		local Success, Result = Bubble.Form(
			Processor:Compile(Name, Argument)
		)
		
		if Success then
			table.insert(Results, Result)
		else
			return false
		end
	end
	
	return true, table.unpack(Results)
end

return Sequence
