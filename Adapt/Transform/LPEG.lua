local Execution = require"Moonrise.Adapt.Execution"
local All, Atleast, Atmost, Sequence, Select, Not, Dematch, Filter =
	require"Moonrise.Adapt.Transform.All",
	require"Moonrise.Adapt.Transform.Atleast",
	require"Moonrise.Adapt.Transform.Atmost",
	require"Moonrise.Adapt.Transform.Sequence",
	require"Moonrise.Adapt.Transform.Select",
	require"Moonrise.Adapt.Transform.Not",
	require"Moonrise.Adapt.Transform.Dematch",
	require"Moonrise.Adapt.Transform.Filter"

local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.LPEG : Adapt.Transform.Compound
---@operator call:Adapt.Transform.LPEG
---@field private Parents table<string, any>
---@field private Children table
local LPEG = OOP.Declarator.Shortcuts(
	"Adapt.Transform.LPEG", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

---@param Instance Adapt.Transform.LPEG
---@param Pattern Adapt.Transform.Base
function LPEG:Initialize(Instance, Pattern)
		LPEG.Parents.Compound:Initialize(Instance, {Pattern = Pattern})
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
function LPEG:Raise(CurrentState, Argument)
	return Execution.Recurse(CurrentState, "Raise", "Pattern", self.Children.Pattern, Argument)
end

---@param CurrentState Adapt.Execution.State
---@param Argument any,
function LPEG:Lower(CurrentState, Argument)
	return Execution.Recurse(CurrentState, "Lower", "Pattern", self.Children.Pattern, Argument)
end

local function UnShell(RHS)
	return OOP.Reflection.Type.Name(RHS) == "Adapt.Transform.LPEG" and UnShell(RHS.Children.Pattern) or RHS
end

--TODO you know
function LPEG:__add(RHS)
	local Union = {}
	
	if OOP.Reflection.Type.Name(self.Children.Pattern) == "Adapt.Transform.Select" then
		for _, SubPattern in pairs(self.Children.Pattern.Children) do
			table.insert(Union, SubPattern)
		end
	else
		table.insert(Union, self.Children.Pattern)
	end
	
	RHS = UnShell(RHS)
	if OOP.Reflection.Type.Name(RHS) == "Adapt.Transform.Select" then
		for _, SubPattern in pairs(RHS.Children) do
			table.insert(Union, SubPattern)
		end
	else
		table.insert(Union, RHS)
	end
	
	return LPEG(Select(Union))
end

function LPEG:__mul(RHS)
	print"??"
	local Union = {}
	
	if OOP.Reflection.Type.Name(self.Children.Pattern) == "Adapt.Transform.Sequence" then
		for _, SubPattern in pairs(self.Children.Pattern.Children) do
			table.insert(Union, SubPattern)
			print(SubPattern)
		end
	else
		table.insert(Union, self.Children.Pattern)
	end
	
	RHS = UnShell(RHS)
	if OOP.Reflection.Type.Name(RHS) == "Adapt.Transform.Sequence" then
		print"Aaa"
		for _, SubPattern in pairs(RHS.Children) do
			table.insert(Union, SubPattern)
		end
	else
		table.insert(Union, RHS)
	end
	
	return LPEG(Sequence(Union))
end

function LPEG:__sub(RHS)
	return LPEG(Dematch(self.Children.Pattern, RHS))
end

function LPEG:__div(RHS)
	return LPEG(Filter(self.Children.Pattern, RHS.Raise, RHS.Lower))
end

function LPEG:__pow(RHS)
	if RHS > 0 then 
		return LPEG(Atleast(RHS, self.Children.Pattern))
	elseif RHS == 0 then
		return LPEG(All(self.Children.Pattern))
	elseif RHS < 0 then
		return LPEG(Atmost(-RHS, self.Children.Pattern))
	end
end

function LPEG:__unm()
	return LPEG(Not(self.Children.Pattern))
end

return LPEG
