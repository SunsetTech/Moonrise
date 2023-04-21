unpack = unpack or table.unpack
table.unpack = table.unpack or unpack
require"Moonrise.Import.Install".All()

local Pretty = require"Moonrise.Tools.Pretty"
local Adapt = require"Moonrise.Adapt"

local Grammar = require"CommandLine";
local CommandLine = require"Moonrise.Tools.CommandLine"

print(Pretty.Any(CommandLine.GetOptions(),2,true))
