local Metric = {}

Metric.Prefixes = {
	yotta =  24;
	zetta =  21;
	exa   =  18;
	peta  =  15;
	tera  =  12;
	giga  =  9;
	mega  =  6;
	kilo  =  3;
	hecto =  2;
	deca  =  1;
	[""]  =  0;
	deci  = -1;
	centi = -2;
	milli = -3;
	micro = -6;
	nano  = -9;
	pico  = -12;
	femto = -15;
	atto  = -18;
	zepto = -21;
	yocto = -24;
}

function Metric.Convert(Value, From, To)
	From = From:lower()
	To = (To or ""):lower()
	
	local Factor = 10 ^ (Metric.Prefixes[From] - Metric.Prefixes[To])

	return Value * Factor
end

return Metric
