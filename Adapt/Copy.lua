local Process = require"Moonrise.Adapt.Process"
return function(Pattern, From, To, Debug)
	local Start = os.time()
	print"Reading..."
	local ReadSuccess, ReadResult = Process(Pattern, "Raise", From, nil, Debug)
	print("Read in", os.time() - Start)
	local WriteSuccess = false
	if ReadSuccess then
		print"Writing.."
		Start = os.time()
		WriteSuccess = Process(Pattern, "Lower", To, ReadResult, Debug)
		print("Write in", os.time() - Start)
	end
	return ReadSuccess, WriteSuccess
end
