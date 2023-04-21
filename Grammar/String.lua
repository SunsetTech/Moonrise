local StringParser; StringParser = {
	Raise = function(Recurse, Argument)
		local Success, Result = Recurse(Argument)
		return Success, Success and table.concat(Result)
	end;
	Lower = function() end;
	Create = function(Pattern)
		return Pattern / StringParser 
	end
} return StringParser;
