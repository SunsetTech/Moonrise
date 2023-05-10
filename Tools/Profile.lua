local Counters = {}

local Profile; Profile = {
	GetCounter = function(Name)
		return Counters[Name] or 0
	end;
	IncrementCounter = function(Name)
		Counters[Name] = Profile.GetCounter(Name) + 1
		return Counters[Name]
	end;
	IncrementCounterAndPrint = function(Name)
		print(Name, Profile.IncrementCounter(Name))
	end;
} return Profile
