unpack = unpack or table.unpack
table.unpack = table.unpack or unpack
require"Moonrise.Import.Install".All()

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
for Key, Value in pairs(Args) do
	if Value == Grammar.Unknown then
		print("Unknown option '".. Key .."'")
	end
end
if Args.help or Args.h then
	print"<-h, --help> print this\n<-p, --print> print a message"
end
if Args.p or Args.print then
	print(Args.p or Args.print)
end
