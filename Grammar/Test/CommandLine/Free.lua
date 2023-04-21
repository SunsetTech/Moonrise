unpack = unpack or table.unpack
table.unpack = table.unpack or unpack
require"Moonrise.Import.Install".All()

local Pretty = require"Moonrise.Tools.Pretty"

local CommandLine = require"Moonrise.Tools.CommandLine"

print(Pretty.Any(CommandLine.GetOptions.Free(),true,2))
