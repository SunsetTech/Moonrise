local Counts = {}
local Pools = {}
local Allocation; Allocation = {
	Increment = function(Arena)
		Arena = Arena or "Unknown"
		Counts[Arena] = (Counts[Arena] or 0) + 1
	end;
	ArenaTotal = function(Arena)
		return Counts[Arena or "Unknown"]
	end;
	GlobalTotal = function()
		local Total = 0
		for _, Count in pairs(Counts) do
			Total = Total + Count
		end
		return Total
	end;
	Grab = function(Arena, Clear)
		Pools[Arena] = Pools[Arena] or {}
		if #Pools[Arena] == 0 then
			return {}
		else
			return table.remove(Pools[Arena])
		end
	end;
	Release = function(Arena, Table)
		Pools[Arena] = Pools[Arena] or {}
		table.insert(Pools[Arena], Table)
	end;
} return Allocation;
