local TF = require"Moonrise.Adapt.Transform"
local Pretty = require"Moonrise.Tools.Pretty"
local StringParser = require"Moonrise.Grammar.String"
local BasicFilters = require"Moonrise.Grammar.Filters"

local Unknown = {}

---@class Moonrise.Grammar.CommandLine.Option
---@field String string
---@field HasArgument boolean

---@type table<string, Adapt.Transform.Filter.Table | fun(...):Adapt.Transform.Filter.Table>
local Filters = {
	Long = function(LongOptions) 
		return {
			Raise = function (Recurse, Argument)
				local Success, Result = Recurse(Argument)
				local Flag = {
				}
				if type(Result) == "table" then
					Flag[Result.Key]=Result.Value
				else
					Flag[Result] = LongOptions[Flag] and true or Unknown
				end
				return Success, Success and Flag
			end
		}
	end;
	
	Short = function(ShortOptions)
		return {
			Raise = function (Recurse, Argument)
				local Success, Result = Recurse(Argument)
				local Flags = {}
				if Success then
					for _, Flag in pairs(Result) do
						if type(Flag) == "table" then
							Flags[Flag.Key] =  Flag.Value
						else
							Flags[Flag] = ShortOptions[Flag] and true or Unknown
						end
					end
				end
				return Success, Success and Flags
			end
		}
	end;
	
	Pair = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and {Key = Result[1], Value=Result[2][1]}
		end
	};
	
	SingleOut = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and (#Result == 1 and Result[1] or Result)
		end;
	};
	
	Combine = {
		Raise = function (Recurse, Argument) 
			local Success, Result = Recurse(Argument)
			local Flags = {}
			if Success then
				for _, FlagTable in pairs(Result) do
					if type(FlagTable) == "table" then
						for Flag, Value in pairs(FlagTable) do
							if type(Flag) == "number" then
								table.insert(Flags, Value)
							else
								Flags[Flag] = Value
							end
						end
					else
						table.insert(Flags, FlagTable)
					end
				end
			end
			return Success, Success and Flags
		end;
	}
}

local CommandLine; CommandLine = {
	Unknown = Unknown;
	---@param String string
	---@param TakesArgument boolean
	---@return Adapt.Transform.String
	OptionPattern = function(String, TakesArgument) 
		local Pattern = TF.String(String)
		if TakesArgument then
			Pattern = (Pattern * TF.Rule"Argument"^-1)/Filters.Pair
		end
		return Pattern
	end;

	---@param ShortOptions table<string,Moonrise.Grammar.CommandLine.Option>
	---@param LongOptions table<string,Moonrise.Grammar.CommandLine.Option>
	Grammar = function (ShortOptions, LongOptions)
		local ShortOptionsPattern = TF.Success(false)
		for Key, ShortOption in pairs(ShortOptions) do
			assert(#Key == 1)
			ShortOptionsPattern = ShortOptionsPattern + CommandLine.OptionPattern(Key, ShortOption.HasArgument)
		end
		
		local LongOptionsPattern = TF.Success(false)
		for Key, LongOption in pairs(LongOptions) do
			LongOptionsPattern = LongOptionsPattern + CommandLine.OptionPattern(Key, LongOption.HasArgument)
		end
		
		return TF.Grammar{
			Seperator = TF.String"<|>";
			
			Argument = TF.Grammar{
				Content = (TF.Bytes(1) - TF.Rule"Seperator" - TF.String"-");
				(
					TF.Rule"Seperator"^-1 
					* StringParser.Create(TF.Rule"Content"^1)
				) / BasicFilters.Sequence(2);
			};
			
			Option = TF.Grammar{
				Short = TF.Grammar{
					Unknown = TF.Bytes(1) - TF.Rule"Seperator" - TF.String"-";
					Known = ShortOptionsPattern / BasicFilters.Select;
					(
						TF.String"-" 
						* (
							(TF.Rule"Known" + TF.Rule"Unknown") / BasicFilters.Select
						)^1
					) / BasicFilters.Sequence(2) / Filters.Short(ShortOptions);
				};
				Long = TF.Grammar{
					Known = LongOptionsPattern / BasicFilters.Select;
					Unknown = StringParser.Create((TF.Bytes(1) - TF.Rule"Seperator" - TF.String"-")^1);
					(
						TF.String"--" 
						* (
							(TF.Rule"Known" + TF.Rule"Unknown") / BasicFilters.Select
						)
					) / BasicFilters.Sequence(2) / Filters.Long(LongOptions);
				};
				(TF.Rule"Long" + TF.Rule"Short")/BasicFilters.Select;
			};
			
			Unpaired = StringParser.Create((TF.Bytes(1) - TF.String"<|>")^1);
			(
				((TF.Rule"Option" + TF.Rule"Unpaired") / BasicFilters.Select)
				* (
					
						(
							(TF.Rule"Seperator" * ((TF.Rule"Option" + TF.Rule"Unpaired")/BasicFilters.Select))
							/ BasicFilters.Sequence(2)
						)^0
					 / Filters.Combine 
				) / Filters.Combine
			);
		}
	end
}; return CommandLine
