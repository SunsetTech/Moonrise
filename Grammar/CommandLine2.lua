local TF = require"Moonrise.Adapt.Transform"

---@class Moonrise.Grammar.CommandLine.Option
---@field String string
---@field HasArgument boolean

local CommandLine; CommandLine = {
	OptionPattern = function(String, TakesArgument) 
		local Pattern = TF.String(String)
		if TakesArgument then
			Pattern = Pattern * TF.Rule"Argument"
		end
	end;

	---@param ShortOptions Moonrise.Grammar.CommandLine.Option[]
	---@param LongOptions Moonrise.Grammar.CommandLine.Option[]
	Grammar = function (ShortOptions, LongOptions)
		local ShortOptionsPattern = TF.Success(false)
		for _, ShortOption in pairs(ShortOptions) do
			assert(#ShortOption.String == 1)
			ShortOptionsPattern = ShortOptionsPattern + CommandLine.OptionPattern(ShortOption.String, ShortOption.HasArgument)
		end
		
		local LongOptionsPattern = TF.Success(false)
		for _, LongOption in pairs(LongOptions) do
			LongOptionsPattern = LongOptionsPattern + CommandLine.OptionPattern(LongOption.String, LongOption.HasArgument)
		end
		
		return TF.Grammar{
			Options = TF.Grammar{
				Short = TF.String"-" * (ShortOptionsPattern^0);
				Long = TF.String"--" * LongOptionsPattern;
				TF.Rule"Long" + TF.Rule"Short"
			};
		}
	end
}; return CommandLine
