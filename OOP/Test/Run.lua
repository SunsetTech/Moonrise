table.unpack = table.unpack or unpack
require"Toolbox.Import.Install".All()

local Benchmark = require"Benchmark"
local Tools = require"Toolbox.Tools"

local Greeter = require"Greeter"

local Question = Greeter("Hello, %s", "?")
local Exclamation = Tools.Copy.Value(Question)
assert(Question == Exclamation)

Exclamation.Punctuation = "!"
assert(Question ~= Exclamation)

print(Question:Punctuate"World", Question:Greet"World")
print(Exclamation:Punctuate"World", Exclamation:Greet"World")

local function Wrap(Index, Max)
	return ((Index-1)%Max)+1
end

local Settings = 
{
	Runs = 100;
	Laps = 250000000;
}

local Punctuations = {
	"?";
	"!";
	".";
}

local Greet = Greeter.__members.Greet
local NewGreeter = Greeter.__new
local ReleaseGreeter = Greeter.__release

local Temp = {}
local Accumulator = 0

Benchmark.Print(
	{
		BOGOLaps = function(Laps)
			for Lap = 1, Laps do
			end
			io.write("BOGO\n")
		end;
		
		--[==[CreateGreeter = function(Laps)
			local Value
			
			for Lap = 1, Laps do
				--Value = Greeter("Hello, %s", "?")
				Temp[Lap] = NewGreeter(Greeter, "Hello, %s", "?")
			end
			
			io.write(Temp[1]:Greet"Benchmark", "\n")
			
			--[[for Lap = 1, Laps do
				ReleaseGreeter(Greeter, Temp[Lap])
			end]]
		end;]==]
		
		Greet = function(Laps)
			local Value
			local Temp = Temp
			local Greet = Greet
			local Exclamation = Exclamation
			local A = 0
			for Lap = 1, Laps do
				A = A + 1
				if A > 1001 then
					A = 1
					Temp[A] = Greet(Exclamation, "?")
				else
					Temp[A] = Greet(Exclamation, "World")
				end
			end
			
			io.write(Value or Temp[1], " ", A, "\n")
		end;
	},
	Settings.Runs,
	Settings.Laps,
	nil,
	true
)
