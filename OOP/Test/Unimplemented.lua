require "Toolbox.Import.Install".All()
local OOP = require"Toolbox.OOP"

local Test = OOP.Define"Test"

local Instance = Test()
print(Instance)
Instance:Method()
