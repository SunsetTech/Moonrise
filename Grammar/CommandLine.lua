local TF = require"Moonrise.Adapt.Transform"
local String = require"Moonrise.Grammar.String"

local NYI = function() error"NYI" end;

---@type table<string, Adapt.Transform.Filter.Table>
local Filters; Filters = {
	LongSwitch = {
		Raise= function(Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and Result[2]
		end;
		Lower = NYI;
	};
	ShortSwitches = {
		Raise = function(Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and Result[2]
		end;
		Lower = NYI;
	};
	Option = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and Result[Result.__which]
		end;
		Lower = NYI;
	};
	SettingValue = {
		Raise = function (Recurse, Argument, CurrentState)
			local Success, Result = Recurse(Argument)
			return Success, Success and Result[2]
		end;
		Lower = NYI;
	};
	Setting = {
		Raise = function (Recurse, Argument, CurrentState)
			local Success, Result = Recurse(Argument)
			return Success, Success and {Key = Result[1]; Value = Result[2][1]}
		end
	};
}

return TF.Grammar{
	Value = String.Create(TF.Bytes(1)^1);
	Key = (TF.Bytes(1) - TF.String"=")^1;
	ShortSwitches = TF.String"-" * TF.Rule"Key";
	LongSwitch = TF.String"--" * String.Create(TF.Rule"Key");
	Option = (
		  TF.Rule"LongSwitch" / Filters.LongSwitch 
		+ TF.Rule"ShortSwitches" / Filters.ShortSwitches
	) / Filters.Option;
	(
		  TF.Rule"Option" 
		* ((TF.String"=" * TF.Rule"Value") / Filters.SettingValue)^-1
	) / Filters.Setting;
}
