--why the Fuck is this the most complicated one

---@diagnostic disable:unused-function
---@diagnostic disable:empty-block

local String = require"Moonrise.Tools.String"
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Jump : Adapt.Transform.Compound
---@operator call:Adapt.Transform.Jump
---@field private SubPath table<integer, string>
Jump = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Jump", {
		require"Moonrise.Adapt.Transform.Compound"
	}
)

function Jump:Initialize(Instance, SubPath)
	Instance.SubPath = SubPath
end

---@alias ExplodedString table<integer, string>

---@param At Adapt.Execution.Location
---@param PathParts ExplodedString
---@return Adapt.Execution.Location | nil #the found nodes location
local function Lookup(At, PathParts)
	for Index, PathPart in pairs(PathParts) do
		local Node = At.Node
		---@cast Node Adapt.Transform.Compound
		if Node.Children then
			local FoundNode = Node.Children[PathPart]
			if FoundNode then
				At = Execution.Location(PathPart, FoundNode, Index > 1 and At or nil) --the weirdness here is so we dont attach to the chain for some reason i forget
				if Index > 1 then
					table.insert(At.Parent.History, At)
					--At.Parent:Push(At)
				end
			else
				return
			end
		else
			return
		end
	end
	return At
end

---@return Adapt.Execution.Location, Adapt.Execution.Location|nil
local function BacktrackingFind(At, PathParts)
	local Found
	repeat
		Found = Lookup(At, PathParts)
		if not Found then
			At = At.Parent
		end
	until At == nil or Found
	return At, Found
end

local function FindRoot(Of)
	if Of.Parent == nil then
		return Of
	else
		return FindRoot(Of.Parent)
	end
end

---@param CurrentState Adapt.Execution.State
function Jump:Raise(CurrentState, Argument) --Root
	local SubPath = String.Explode(self.SubPath, ".")
	local Where,Found = BacktrackingFind(CurrentState.RootLocation:GetHead(), SubPath)
	local RootOf = FindRoot(Found)

	Where:PushLocation(RootOf)
		local Node = Found.Node
		local Success, Result = Found.Node:Raise(CurrentState, Argument)
	Where:Pop(RootOf)
	
	return Success, Result
end

---@param CurrentState Adapt.Execution.State
function Jump:Lower(CurrentState, Argument) --Root
	local SubPath = String.Explode(self.SubPath, ".")
	local Where,Found = BacktrackingFind(CurrentState.RootLocation:GetHead(), SubPath)
	local RootOf = FindRoot(Found)
	
	Where:PushLocation(RootOf)
		local Success, Result = Found.Node:Lower(CurrentState, Argument)
	Where:Pop(RootOf)
	
	return Success, Result
end

return Jump

