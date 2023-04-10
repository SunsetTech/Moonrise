unpack=unpack or table.unpack
require"Moonrise.Import.Install".All()

local Adapt = require"Moonrise.Adapt"
local Transform = Adapt.Transform
local           Repeated,           Select,           Sequence,           String 
	= Transform.Repeated, Transform.Select, Transform.Sequence, Transform.String

local Pattern = Transform.Grammar{
	Transform.Grammar{Transform.Jump"A.Test"};
	A = Transform.Grammar{ 
		Test = Transform.String"Hello"
	};
}

local ReadBuffer = Adapt.Stream.File("./Input", "r")
local ReadSuccess, ReadResult = Adapt.Process(Pattern,"Raise",ReadBuffer)
if ReadSuccess then
	local WriteBuffer = Adapt.Stream.File("./Output", "w")
	local WriteSuccess = Adapt.Process(Pattern,"Lower",WriteBuffer, ReadResult)
	
	print(WriteSuccess and "Success" or "Failure")
end
