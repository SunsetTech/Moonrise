--why the Fuck is this the most complicated one

---@diagnostic disable:unused-function
---@diagnostic disable:empty-block

local String = require"Moonrise.Tools.String"
local OOP = require"Moonrise.OOP"

local Execution = require"Moonrise.Adapt.Execution"

---@class Adapt.Transform.Jump : Adapt.Transform.Base
---@operator call:Adapt.Transform.Jump
---@field private SubPath table<integer, string>
Jump = OOP.Declarator.Shortcuts(
	"Adapt.Transform.Jump", {
		require"Moonrise.Adapt.Transform.Base"
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
	--for Index, PathPart in pairs(PathParts) do
	for Index = 1, #PathParts do
		local PathPart = PathParts[Index]
		local Node = At.Node
		---@cast Node Adapt.Transform.Compound
		if Node.Children then
			local TargetNode = Node.Children[PathPart]
			if TargetNode then
				At = Execution.Location(PathPart, TargetNode, Index > 1 and At or nil) --the weirdness here is so we dont attach to the chain for some reason i forget
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

---@param At Adapt.Execution.Location
---@param PathParts string[]
---@return Adapt.Execution.Location, Adapt.Execution.Location|nil
local function Backtrack(At, PathParts)
	local Target
	repeat
		Target = Lookup(At, PathParts)
		if not Target then
			At = At.Parent
		end
	until At == nil or Target
	return At, Target
end

local function FindRoot(Of)
	if Of.Parent == nil then
		return Of
	else
		return FindRoot(Of.Parent)
	end
end

---@param MethodName string
---@param CurrentState Adapt.Execution.State
---@param Argument any
function Jump:Execute(MethodName, CurrentState, Argument) --Root
	local Where, RootOf, Target
	
	if not CurrentState.JumpCache[self] then
		local SubPath = String.Explode(self.SubPath, ".")
		Where,Target = Backtrack(CurrentState.RootLocation:GetHead(), SubPath)
		
		if Target == nil then
			error("Didn't find rule`".. self.SubPath .."` in grammar")
		end
		
		RootOf = FindRoot(Target)
		RootOf.Parent = Where
		
		CurrentState.JumpCache[self]={
			Where = Where,
			RootOf = RootOf,
			Target = Target
		}
	else
		local Cached = CurrentState.JumpCache[self]
		Where, RootOf, Target = Cached.Where, Cached.RootOf, Cached.Target
	end
	
	Where:PushLocation(RootOf)
		local Success, Result = Execution.Execute(CurrentState, MethodName, Target, Argument)
	Where:Pop(RootOf)
	
	return Success, Result
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

