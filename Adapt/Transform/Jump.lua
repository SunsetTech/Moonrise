--why the Fuck is this the most complicated one

---@diagnostic disable:unused-function
---@diagnostic disable:empty-block

local String = require"Moonrise.Tools.String"
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Jump : Adapt.Transform.Base
---@operator call:Adapt.Transform.Jump
---@field public SubPath table<integer, string>
Jump = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Jump", {
		require"Moonrise.Adapt.Transform.Base"
	}
)

function Jump:Initialize(Instance, SubPath)
	Instance.SubPath = SubPath
end


---@param MethodName string
---@param CurrentState Adapt.Execution.State
---@param Argument any
function Jump:Execute(MethodName, CurrentState, Argument) --Root
	return true, nil, CurrentState.JumpMap[self], Argument
	--return Execution.Recurse(CurrentState, MethodName, CurrentState.JumpMap[self], Argument)
end

function Jump:Raise(CurrentState, Argument)
	return self:Execute("Raise", CurrentState, Argument)
end

function Jump:Lower(CurrentState, Argument) --Root
	return self:Execute("Lower", CurrentState, Argument)
end

function Jump:Optimize()
	Jump.Parents.Base.Optimize(self)
	self.Execute = Jump.Execute
end

function Jump:__tostring()
	return "Jump'".. self.SubPath .."'"
end

return Jump

