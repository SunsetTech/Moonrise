local Pretty = require"Moonrise.Tools.Pretty"
NYI = function() error"NYI" end

---@type table<string, Adapt.Transform.Filter.Table | fun(...):Adapt.Transform.Filter.Table>
return {
	--[[Select = function(Remap) 
		return {
			Raise = function (Recurse, Argument)
				local Success, Result = Recurse(Argument)
				return Success, Success and Result[Result.__which] or nil
			end;
			Lower = function(Recurse, Argument)
				local Index = Remap(Argument)
				return Recurse{[Index] = Argument, __which = Index}
			end;
		}
	end;]]
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
	
	---@param NameMap table
	---@return Adapt.Transform.Filter.Table
	Map = function(NameMap)
		return {
			Raise = function (Recurse, Argument)
				local Success, Result = Recurse(Argument)
				local ValueMap = {}
				if Success then
					for Name, Index in pairs(NameMap) do
						ValueMap[Name] = Result[Index]
					end
				end
				return Success, Success and ValueMap
			end;
			Lower = function(Recurse, Argument)
				local ValueMap = {}
				for Name, Index in pairs(NameMap) do
					ValueMap[Index] = Argument[Name]
				end
				return Recurse(ValueMap)
			end;
		}
	end;
}
