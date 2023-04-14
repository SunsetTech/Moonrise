unpack=unpack or table.unpack
require"Moonrise.Import.Install".All()

local Adapt = require"Moonrise.Adapt"

local TestBuffer = Adapt.Stream.String""
TestBuffer:Write"ass"
TestBuffer:Write"hello"
--[[print(TestBuffer:Read(3), TestBuffer:Read(1))
TestBuffer:Goto(1)
TestBuffer:Write"tE"
TestBuffer:Goto(2)
TestBuffer:Write"in"]]
print(TestBuffer.Contents)
