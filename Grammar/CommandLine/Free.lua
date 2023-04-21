local TF = require"Moonrise.Adapt.Transform"
local String = require"Moonrise.Grammar.String"
local BuiltinFilters = require"Moonrise.Grammar.Filters"

---@type table<string, Adapt.Transform.Filter.Table>
local Filters = {
	Setting = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and {Key = Result[1]; Value = Result[2][1]}
		end
	};
}

return TF.Grammar{
	Value = String.Create(TF.Bytes(1)^1);
	Key = (TF.Bytes(1) - TF.String"=")^1;
	ShortSwitches = TF.String"-" * TF.Rule"Key" / BuiltinFilters.Sequence(2);
	LongSwitch = TF.String"--" * String.Create(TF.Rule"Key") / BuiltinFilters.Sequence(2);
	Option = (TF.Rule"LongSwitch" + TF.Rule"ShortSwitches") / BuiltinFilters.Select;
	(
		  TF.Rule"Option" 
		* (
			(TF.String"=" * TF.Rule"Value") / BuiltinFilters.Sequence(2)
		)^-1
	) / Filters.Setting;
}
