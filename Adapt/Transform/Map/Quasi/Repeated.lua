local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Repeated = OOP.Declarator.Shortcuts(
	"Adapt.Element.Repeated", {
		Module.Sister"Compound"
	}
)

function Repeated:Initialize(Inner, Count, Exact)
		Repeated.Parents.Compound:Initialize(Instance, {Inner = Inner})
	
	Instance.Count = Count
	Instance.Exact = Exact or false
end

function Repeated:Split(Processor, Arguments)
	if self.Exact then --Exactly
	elseif self.Count == 0 then --Greedy TODO just this one for now
	elseif self.Count < 0 then --Atleast
	elseif self.Count > 0 then --Atmost
	end
end

function Repeated:Fuse(Processor, Arguments)
	if self.Exact then --Exactly
	elseif self.Count == 0 then --Greedy TODO ditto
	elseif self.Count < 0 then --Atleast
	elseif self.Count > 0 then --Atmost
	end
end

return Repeated
