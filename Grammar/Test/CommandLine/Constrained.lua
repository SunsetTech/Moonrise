unpack = unpack or table.unpack
table.unpack = table.unpack or unpack
require"Moonrise.Import.Install".All()

local Pretty = require"Moonrise.Tools.Pretty"

local CommandLine = require"Moonrise.Tools.CommandLine"
local Grammar = require"Moonrise.Grammar.CommandLine.Constrained"

local Args = CommandLine.GetOptions.Constrained(
	{
		h={};
		p={HasArgument=true};
	},
	{
		help={HasArgument=false};
		print={HasArgument=true};
	}
)
print(Pretty.Any(Args,true,2))
for Key, Value in pairs(Args) do
	if Value == Grammar.Unknown then
		print("Unknown option ".. Key)
	end
end
if Args.help or Args.h then
	print"<-h, --help> print this <-p, --print> print a message"
end
if Args.p or Args.print then
	print(Args.p or Args.print)
end
