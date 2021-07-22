local cqueues = require"cqueues"
local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Pool = OOP.Declarator.Shortcuts(
	"Threading.Pool", {
		Module.Sister"Routine"
	}
)

function Pool:Initialize(Instance, ...)
	Instance.Scheduler = cqueues.new()
	
	for _, Subroutine in pairs{...} do
		Instance:Add(Subroutine)
	end
end

function Pool:Add(Subroutine)
	self.Scheduler:wrap(
		function()
			Subroutine:Start()
		end
	)
end

function Pool:Step()
	local Success, Error = self.Scheduler:step()
	
	if not Success then
		error(Error)
	end
end

function Pool:Loop()
	while not self.Scheduler:empty() do
		self:Step()
	end
end

return Pool
