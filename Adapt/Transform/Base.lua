local OOP = require"Moonrise.OOP"

---@class Adapt.Transform.Base
---@operator call(): Adapt.Transform.Base 
local Base = OOP.Declarator.Shortcuts"Adapt.Transform.Base"

function Base:Initialize()
	self:Optimize()
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
---@diagnostic disable-next-line:unused-local 
function Base:Lower(CurrentState, Argument) ---@diagnostic disable-line:unused-vararg
	error":Lower not implemented"
end

---@param CurrentState Adapt.Execution.State
---@param Argument any
---@diagnostic disable-next-line:unused-local
function Base:Raise(CurrentState, Argument) ---@diagnostic disable-line:unused-vararg
	error":Raise not implemented"
end

function Base:Optimize()
	--print("Optimizing", self)
	self.Raise = self.Raise
	self.Lower = self.Lower
end

---@param RHS Adapt.Transform.Base
function Base:__add(RHS)
	local Union = {}
	
	if OOP.Reflection.Type.Name(self) == "Adapt.Transform.Select" then
		---@cast self Adapt.Transform.Select
		for _, SubPattern in pairs(self.Children) do
			table.insert(Union, SubPattern)
		end
	else
		table.insert(Union, self)
	end
	
	if OOP.Reflection.Type.Name(RHS) == "Adapt.Transform.Select" then
		---@cast RHS Adapt.Transform.Select
		for _, SubPattern in pairs(RHS.Children) do
			table.insert(Union, SubPattern)
		end
	else
		table.insert(Union, RHS)
	end
	
	return Select(Union)
end

---@param RHS Adapt.Transform.Base
function Base:__mul(RHS)
	local Sequence = require"Moonrise.Adapt.Transform.Sequence"
	local Union = {}
	
	if OOP.Reflection.Type.Name(self) == "Adapt.Transform.Sequence" then
		---@cast self Adapt.Transform.Sequence
		for _, SubPattern in pairs(self.Children) do
			table.insert(Union, SubPattern)
		end
	else
		table.insert(Union, self)
	end
	
	if OOP.Reflection.Type.Name(RHS) == "Adapt.Transform.Sequence" then
		---@cast RHS Adapt.Transform.Sequence
		for _, SubPattern in pairs(RHS.Children) do
			print(SubPattern)
			table.insert(Union, SubPattern)
		end
	else
		table.insert(Union, RHS)
	end
	
	return Sequence(Union)
end

---@param RHS Adapt.Transform.Base
---@return Adapt.Transform.Dematch
function Base:__sub(RHS)
	local Dematch = require"Moonrise.Adapt.Transform.Dematch"
	return Dematch(self, RHS)
end

---@param RHS Adapt.Transform.Filter.Table
---@return Adapt.Transform.Filter
function Base:__div(RHS)
	local Filter = require"Moonrise.Adapt.Transform.Filter"
	return Filter(self, RHS.Raise, RHS.Lower)
end

---@param RHS integer
---@return Adapt.Transform.Atleast
function Base:__pow(RHS)
	if RHS > 0 then 
		local Atleast = require"Moonrise.Adapt.Transform.Atleast"
		return Atleast(RHS, self)
	elseif RHS == 0 then
		local All = require"Moonrise.Adapt.Transform.All"
		return All(self)
	elseif RHS < 0 then
		local Atmost = require"Moonrise.Adapt.Transform.Atmost"
		return Atmost(-RHS, self)
	else
		error"Oops"
	end
end

function Base:__unm()
	local Not = require"Moonrise.Adapt.Transform.Not"
	return Not(self)
end

return Base
