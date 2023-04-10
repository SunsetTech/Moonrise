local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@alias MethodName '"Raise"'|'"Lower"'

---@class Adapt.Transform.Select : Adapt.Transform.Compound
---@operator call(): Adapt.Transform.Select
Select = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Select", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

---@param ExecutionState Adapt.Execution.State
---@param MethodName MethodName
---@param Index number
---@param Child table
---@param Argument any
---@param Bookmark table
---@return boolean, table|nil
local function TryChild(ExecutionState, MethodName, Index, Child, Argument, Bookmark)
	local Success, Result = Execution.Recurse(
		ExecutionState,
		MethodName, Index, Child,
		Argument
	)
	
	if not Success then
		ExecutionState:Rewind(Bookmark)
		return false
	else
		return Success, {[Index] = Result, __which=Index}
	end
end

---@param ExecutionState Adapt.Execution.State
---@param MethodName MethodName
---@param ArgumentMap table|nil
---@return boolean, table|nil
function Select:TryChildren(ExecutionState, MethodName, ArgumentMap)
	ArgumentMap = ArgumentMap or {}
	local Bookmark = ExecutionState:Mark()
	if (ArgumentMap.__which) then --the user or a previous parse indicated which branch to take
		local Index = ArgumentMap.__which
		local Argument = ArgumentMap[Index]
		local Child = self.Children[Index]
		local Success, Result = TryChild(ExecutionState, MethodName, Index, Child, Argument, Bookmark)
		if Success then
			return Success, Result
		else
			return false
		end
	else --gotta try 'em all, Parsemon
		for Index,Child in pairs(self.Children) do
			local Argument = ArgumentMap[Index]
			local Success, Result = TryChild(ExecutionState, MethodName, Index, Child, Argument, Bookmark)
			if Success then
				return Success, Result
			end
		end
		return false
	end
end

---@param ExecutionState Adapt.Execution.State
---@param ArgumentMap table|nil
---@return boolean, table|nil
function Select:Raise(ExecutionState, ArgumentMap)
	return self:TryChildren(ExecutionState, "Raise", ArgumentMap)
end

---@param ExecutionState Adapt.Execution.State
---@param ArgumentMap table|nil
---@return boolean, table|nil
function Select:Lower(ExecutionState, ArgumentMap)
	return self:TryChildren(ExecutionState, "Lower", ArgumentMap)
end

return Select

