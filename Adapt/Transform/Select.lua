local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Select : Adapt.Transform.Compound
---@operator call(): Adapt.Transform.Select
Select = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Select", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

---@param CurrentState Adapt.Execution.State
---@param MethodName Adapt.MethodName
---@param Index string
---@param Child table
---@param Argument any
---@param Bookmark table
---@return boolean, table|nil
local function TryChild(CurrentState, MethodName, Index, Child, Argument, Bookmark)
	assert(Child)
	local Success, Result = Execution.Recurse(
		CurrentState,
		MethodName, Child,
		Argument
	)
	
	if not Success then
		CurrentState:Rewind(Bookmark)
		return false
	else
		return Success, {[Index] = Result, __which=Index}
	end
end

---@param CurrentState Adapt.Execution.State
---@param MethodName Adapt.MethodName
---@param ArgumentMap table|nil
---@return boolean, table|nil
function Select:TryChildren(CurrentState, MethodName, ArgumentMap)
	ArgumentMap = ArgumentMap or {}
	local Bookmark = CurrentState:Mark()
	if MethodName == "Lower" then
		--assert(ArgumentMap.__which ~= nil)
	end
	if (ArgumentMap.__which) then --the user or a previous parse indicated which branch to take
		local Index = ArgumentMap.__which
		local Argument = ArgumentMap[Index]
		local Child = self.Children[Index]
		local Success, Result = TryChild(CurrentState, MethodName, Index, Child, Argument, Bookmark)
		if Success then
			return Success, Result
		else
			return false
		end
	else --gotta try 'em all, Parsemon
		for Index,Child in pairs(self.Children) do
			local Argument = ArgumentMap[Index]
			local Success, Result = TryChild(CurrentState, MethodName, Index, Child, Argument, Bookmark)
			if Success then
				return Success, Result
			end
		end
		return false
	end
end

---@param CurrentState Adapt.Execution.State
---@param ArgumentMap table|nil
---@return boolean, table|nil
function Select:Raise(CurrentState, ArgumentMap)
	return self:TryChildren(CurrentState, "Raise", ArgumentMap)
end

---@param CurrentState Adapt.Execution.State
---@param ArgumentMap table|nil
---@return boolean, table|nil
function Select:Lower(CurrentState, ArgumentMap)
	--print(ArgumentMap.__which)
	return self:TryChildren(CurrentState, "Lower", ArgumentMap)
end

function Select:__tostring()
	local Parts = {}
	for _, Child in pairs(self.Children) do
		table.insert(Parts, tostring(Child))
	end
	return "(".. table.concat(Parts, " + ") ..")"
end

return Select

