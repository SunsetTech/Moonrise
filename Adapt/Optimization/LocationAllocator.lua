local Location = require"Moonrise.Adapt.Execution.Location"

local AllocationCount = 0
local DeallocationCount = 0

---@type Adapt.Execution.Location[]
local Pool = {}
local TotalAllocations = 0
local LocationAllocator; LocationAllocator = {
	Harf = function()
		TotalAllocations = TotalAllocations + 1
	end;
	Barf = function()
		return TotalAllocations
	end;
	Allocate = function (Name, Node, Parent)
		LocationAllocator.CountAllocation()
		local New
		if #Pool > 0 then
			---@type Adapt.Execution.Location
			New = table.remove(Pool)
			New.Node = Node
			New.Name = Name
			New.Parent = Parent
			for Index = 1, #New.History do
				New.History[Index] = nil
			end
		else
			New = Location(Name, Node, Parent)
		end
		return New
	end;

	---@param What Adapt.Execution.Location
	Deallocate = function(What)
		LocationAllocator.CountDeallocation()
		table.insert(Pool, What)
	end;
	
	CountAllocation = function()
		AllocationCount = AllocationCount+1
	end;
	
	CountDeallocation = function ()
		DeallocationCount = DeallocationCount+1
	end;
	
	GetAllocationCount = function()
		return AllocationCount
	end;
	
	GetDeallocationCount = function ()
		return DeallocationCount
	end;
	
	GetMismatchCount = function ()
		return AllocationCount - DeallocationCount
	end
}; return LocationAllocator;
