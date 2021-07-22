local posix = require"posix"

local Time; Time = {
	NanoToMilli = function(NS)
		return math.floor(NS/1000000)
	end;
	
	SecondsToMilli = function(S)
		return S*1000
	end;
	
	Wall = function()
		local S, NS = posix.clock_gettime(posix.CLOCK_REALTIME)
		return Time.SecondsToMilli(S) + Time.NanoToMilli(NS)
	end;
}; return Time
