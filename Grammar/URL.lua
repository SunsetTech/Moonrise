local TF = require"Moonrise.Adapt.Transform"

local function NYC()
	error"Not Yet Coded"
end

local StringParser; StringParser = {
	Raise = function(Recurse, Argument)
		local Success, Result = Recurse(Argument)
		return Success, Success and table.concat(Result)
	end;
	Lower = NYC;
	Create = function(Pattern)
		return Pattern / StringParser 
	end
}

---@type table<string,table<Adapt.MethodName, Adapt.Transform.Filter.Method>>
local Filters = {
	Protocol = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and Result[1]
		end;
		Lower = NYC;
	};
	Domain = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			local Parts = {Result[1]}
			for _, Part in pairs(Result[2]) do
				table.insert(Parts, Part[2])
			end
			return Success, Parts
		end;
		Lower = NYC;
	};
	Port = {
		Raise = function(Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Result
		end;
		Lower = NYC;
	};
	Path = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			local Parts = {}
			for _, Part in pairs(Result) do
				table.insert(Parts, Part[2])
			end
			return Success, Parts

		end;
		Lower = NYC;
	};
	Parameter = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and {Key = Result[1]; Value=Result[3]}
		end;
		Lower = NYC;
	};
	Parameters = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			local Parts={Result[2]}
			for Index = 3, #Result do
				if Result[Index][1] then
					table.insert(Parts, Result[Index][1][2])
				end
			end
			return Success, Success and Parts
		
		end;
		Lower = NYC;
	};
	URL = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and {
				Protocol = Result[1][1];
				Domain = Result[2];
				Port = (Result[3][1] and Result[3][1][2] or "");
				Path = Result[4][1];
				Parameters = Result[5][1];
			}
		end;
		Lower = NYC;
	};
}

return TF.Grammar{
	Protocol = (
		StringParser.Create(
			(
				TF.Bytes(1) 
				- TF.String"://"
			) ^ 0
		)
		* TF.String"://"
	) / Filters.Protocol;
	
	Domain = TF.Grammar{
		Segment = StringParser.Create(
			TF.All(
				TF.Dematch(
					TF.Bytes(1), 
					TF.Set"./:"
				)
			)
		);
		
		TF.Filter(
			TF.Sequence{
				TF.Rule"Segment",
				TF.Atleast(
					1, TF.Sequence{
						TF.String".",
						TF.Rule"Segment"
					}
				)
			},
			Filters.Domain.Raise,
			Filters.Domain.Lower
		)
	};

	Port = TF.String":" * StringParser.Create(TF.Range("0","9")^1); --TF.Sequence{TF.String":", StringParser.Create(TF.Atleast(1, TF.Range("0","9")))};

	Path = TF.Grammar{
		Segment = StringParser.Create(TF.All(TF.Dematch(TF.Bytes(1), TF.Set"/?")));
		TF.Filter(
			TF.Atleast(
				1, TF.Sequence{
					TF.Atleast(1, TF.String"/"), 
					TF.Rule"Segment"
				}
			),
			Filters.Path.Raise,
			Filters.Path.Lower
		);
	};
	
	Parameters = TF.Grammar{
		Segment = TF.Grammar{
			Key = StringParser.Create(
				(TF.Bytes(1) - TF.String"=")^1
			);
			Value = StringParser.Create(
				(TF.Bytes(1) - TF.String"&")^1
			);
			(
				TF.Rule"Key"* TF.String"=" * TF.Rule"Value"
			) / Filters.Parameter
		};
		(
			TF.String"?"
			* TF.Rule"Segment"
			* (
				TF.String"&"
				* TF.Rule"Segment"
			)^0
		) / Filters.Parameters;
	};
	(
		TF.Rule"Protocol"^-1
		* TF.Rule"Domain"
		* (TF.Rule"Port"^-1)
		* (TF.Rule"Path"^-1)
		* (TF.Rule"Parameters"^-1)
	) / Filters.URL;
} --TODO this definitely parses things which are not URLs too
