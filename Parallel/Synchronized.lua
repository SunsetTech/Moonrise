local lanes = require"lanes"
local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Portal = Module.Sister"Portal"

local Synchronized = OOP.Declarator.Shortcuts(
	"Threading.Synchronized", {
		Module.Sister"Routine"
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
