local Pretty = require"Moonrise.Tools.Pretty"
local URL = arg[1]

unpack = unpack or table.unpack
table.unpack = table.unpack or unpack
require"Moonrise.Import.Install".All()
local Adapt = require"Moonrise.Adapt"

local URLGrammar = require"URL";
local Success, Result = Adapt.Process(URLGrammar, "Raise", Adapt.Stream.String(URL), nil)
print(Success)
print(Pretty.Table(Result or {},2,true))
