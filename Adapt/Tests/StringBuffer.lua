unpack=unpack or table.unpack
require"Moonrise.Import.Install".All()

local Adapt = require"Moonrise.Adapt"

local TestBuffer = Adapt.Stream.Buffer"Test"
print(TestBuffer:Read(3), TestBuffer:Read(1))
TestBuffer:Goto(1)
TestBuffer:Write"tE"
TestBuffer:Goto(2)
TestBuffer:Write"in"
TestBuffer:Goto(1)
print(TestBuffer:Read(4))
