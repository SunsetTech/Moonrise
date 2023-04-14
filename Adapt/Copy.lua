local Process = require"Moonrise.Adapt.Process"
return function(Pattern, From, To, Debug)
	print"Reading..."
	local ReadSuccess, ReadResult = Process(Pattern, "Raise", From, nil, Debug)
	local WriteSuccess = false
	if ReadSuccess then
		print"Writing..."
		WriteSuccess = Process(Pattern, "Lower", To, ReadResult, Debug)
	end
	return ReadSuccess, WriteSuccess
end
