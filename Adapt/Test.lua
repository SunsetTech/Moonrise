unpack=table.unpack
require"Moonrise.Import.Install".All()

local Adapt = require"Moonrise.Adapt"
local Transform = Adapt.Transform
local Repeated, Select, Sequence, String = Transform.Repeated, Transform.Select, Transform.Sequence, Transform.String

local Pattern = Repeated(
	0, Repeated(2, 
		Select{
			String"a";
			Sequence{
				String"b",
				Repeated(0, String"c")
			};
		}
	)
)

local ReadBuffer = Adapt.Stream.File("./Input", "r")
	local ReadSuccess, ReadResult = Adapt.Process(Pattern,"Raise",ReadBuffer)
print(ReadSuccess, ReadResult())

local WriteBuffer = Adapt.Stream.File("./Output", "w")
	local WriteSuccess, WriteResult = Adapt.Process(Pattern,"Lower",WriteBuffer, ReadResult)
print(WriteSuccess)
