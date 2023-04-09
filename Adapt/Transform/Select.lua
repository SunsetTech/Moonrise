---@class ExecutionState
---@field public Mark fun(self: ExecutionState): any
---@field public Rewind fun(self: ExecutionState, Bookmark: any): nil


local Module = require"Moonrise.Import.Module"
---@type table
local OOP = require"Moonrise.OOP"

---@type table
local Execution = Module.Relative"Execution"

---@alias MethodName '"Raise"'|'"Lower"'

---@class Select
---@field public Children table
---@field public Raise fun(self: Select, ExecutionState: ExecutionState, ArgumentMap: table|nil): boolean, table|nil
---@field public Lower fun(self: Select, ExecutionState: ExecutionState, ArgumentMap: table|nil): boolean, table|nil
---@field private TryChildren fun(self: Select, ExecutionState: ExecutionState, MethodName: MethodName, ArgumentMap: table|nil): boolean, table|nil
Select = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Select", {
		Module.Sister"Compound"
	}
)

---@param ExecutionState ExecutionState
---@param MethodName MethodName
---@param Index number
---@param Child table
---@param Argument any
---@param Bookmark any
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

---@param ExecutionState ExecutionState
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

---@param ExecutionState ExecutionState
---@param ArgumentMap table|nil
---@return boolean, table|nil
function Select:Raise(ExecutionState, ArgumentMap)
	return self:TryChildren(ExecutionState, "Raise", ArgumentMap)
end

---@param ExecutionState ExecutionState
---@param ArgumentMap table|nil
---@return boolean, table|nil
function Select:Lower(ExecutionState, ArgumentMap)
	return self:TryChildren(ExecutionState, "Lower", ArgumentMap)
end

return Select

