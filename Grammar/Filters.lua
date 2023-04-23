local Pretty = require"Moonrise.Tools.Pretty"
NYI = function() error"NYI" end

---@type table<string, Adapt.Transform.Filter.Table | fun(...):Adapt.Transform.Filter.Table>
return {
	Select = {
		__DebugName = "Select";
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and Result[Result.__which]
		end
	};
	Sequence = function(Index) 
		return {
			__DebugName = "Sequence(".. Index ..")";
			Raise = function (Recurse, Argument)
				local Success, Result = Recurse(Argument)
				return Success, Success and Result[Index]
			end;
		}
	end;
	Debug = function(Prefix)
		return {
			Raise = function (Recurse, Argument)
				local Success, Result = Recurse(Argument)
				print(Prefix or "Debug", Success, Pretty.Any(Result,true,2))
				return Success, Result
			end;
			Lower = NYI;
		};
	end;
	MapSequence = function(NameMap)
		---@type Adapt.Transform.Filter.Table
		local FilterTable = {
			Raise = function (Recurse, Argument, CurrentState)
				local Success, Result = Recurse(Argument)
				local ValueMap = {}
				if Success then
					for Name, Index in pairs(NameMap) do
						ValueMap[Name] = Result[Index]
					end
				end
				return Success, Success and ValueMap
			end
		}
		return FilterTable
	end;
}
