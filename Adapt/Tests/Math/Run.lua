unpack = table.unpack
require"Moonrise.Import.Install".All()

local Adapt = require"Moonrise.Adapt"

local Stream = Adapt.Stream
local Element = Adapt.Element
local Bubble = Adapt.Bubble

local Grammar = Element.Compound{
	Main = Stream.Convert(
		Add{
			Integer(),
			Integer()
		}
	);
		
	--[[Element.Sequence{
		Element.String"Foo", 
		Element.Select{
			Element.String"Bar",
			Element.String"Baz"
		},
		Element.Bytes"b"
	}]]
}

local Input = Adapt.Processor(Stream.File("Tests/Simple/Input", "r"), Grammar)
local Output = Adapt.Processor(Stream.File("Tests/Simple/Output", "w"), Grammar)

local Success, A, B, C = Input:Decompile"Main"
assert(Success)

Success = Output:Compile("Main", {A, B, C})
assert(Success)
