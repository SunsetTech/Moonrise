require"Moonrise.Import.Install".All()

local OOP = require"Moonrise.OOP"
local UniqueKey = require"Moonrise.Object.UniqueKey"

print(OOP.Reflection.Type.Of(UniqueKey, UniqueKey()))
