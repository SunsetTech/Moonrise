unpack=unpack or table.unpack
require"Moonrise.Import.Install".All()

local Adapt = require"Moonrise.Adapt"
local Transform = Adapt.Transform

Pattern = Transform.Sequence{
	Transform.Grammar{
		Delimiter = Transform.String'"';
		Open = Transform.Jump"Delimiter";
		Close = Transform.Jump"Delimiter";
		Contents = Transform.Repeat(
			0, Transform.Dematch(
				Transform.Range(0,127),
				Transform.Jump"Delimiter"
			)
		);
		Transform.Sequence{
			Transform.Jump"Delimiter";
			Transform.Jump"Contents";
			Transform.Jump"Delimiter";
		}
	};
	Transform.Dematch(
		Transform.Bytes(1), Transform.Bytes(2)
	)
}

local ReadBuffer = Adapt.Stream.File("./Input", "rb")
local WriteBuffer = Adapt.Stream.File("./Output", "wb")
print(Adapt.Copy(Pattern, ReadBuffer, WriteBuffer))

