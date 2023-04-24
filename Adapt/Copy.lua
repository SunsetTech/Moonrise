
local posix = require("posix")
local Process = require "Moonrise.Adapt.Process"
local Pretty = require"Moonrise.Tools.Pretty"

-- Function to get the current time in seconds with nanosecond precision
local function getTime()
    local s, ns = posix.clock_gettime(posix.CLOCK_REALTIME)
    return s + ns*1e-9
end

return function(Pattern, From, To, Debug, IgnoreDebug)
    local Start = getTime()
    print("Reading...")
    local ReadSuccess, ReadResult, NameMap, JumpMap = Process(Pattern, "Raise", From, nil, Debug, nil, nil, IgnoreDebug)
    print("Read in", getTime() - Start)
    local WriteSuccess = false
    if ReadSuccess then
		print(Pretty.Any(ReadResult, true, 2))
        print("Writing..")
        Start = getTime()
        WriteSuccess = Process(Pattern, "Lower", To, ReadResult, Debug, NameMap, JumpMap)
        print("Write in", getTime() - Start)
    end
    return ReadSuccess, WriteSuccess
end

