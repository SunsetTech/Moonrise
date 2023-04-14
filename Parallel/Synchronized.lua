local OOP = require"Moonrise.OOP"

local Portal = require"Moonrise.Parallel.Portal"

local Synchronized = OOP.Declarator.Shortcuts(
	"Threading.Synchronized", {
		require"Moonrise.Parallel.Routine"
	}
)

function Synchronized:Initialize(Instance)
	Instance.Channel = Portal()
end

function Synchronized:Step()
	for _, Request in pairs(self.Channel:GetRequests()) do
		self:HandleRequest(Request.Tags, Request.Info)
	end
end

return Synchronized
