local StringTools = require"Moonrise.Tools.String"
local Bubble = require"Moonrise.Adapt.Execution.Bubble"
local StringParser; StringParser = {
	Raise = function(Recurse, Argument)
		local Success, Result = Recurse(Argument)
		return Success, Success and table.concat(Result)
	end;
	Lower = function(Recurse, Argument)
		Argument = Bubble.Form(unpack(StringTools.Explode(Argument)))
		return Recurse(Argument)
	end;
	Create = function(Pattern)
		return Pattern / StringParser 
	end
} return StringParser;
