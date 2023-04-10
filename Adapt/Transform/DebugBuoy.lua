
local OOP = require"Moonrise.OOP"

DebugBuoy = OOP.Declarator.Shortcuts(
	"Adapt.Transform.DebugBuoy", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function DebugBuoy:Initialize(Instance, Msg)
	Instance.Msg = Msg
end

function DebugBuoy:Raise() --Root
	print(self.Msg)
	return true
end

function DebugBuoy:Lower()
	print(self.Msg)
	return true
end

return DebugBuoy

