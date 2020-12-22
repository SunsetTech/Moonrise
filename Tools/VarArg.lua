local VarArg = {}

function VarArg.Count(...)
	return select('#', ...)
end

function VarArg.MapReduce(Apply, Merge, Current, ...)
	if Apply then
		Current = Apply(Current)
	end
	
	if VarArg.Count(...) > 0 then
		if Merge then
			return Merge(
				Current,
				VarArg.MapReduce(
					Apply, Merge,
					...
				)
			)
		else
			return 
				Current,
				VarArg.MapReduce(
					Apply, Merge,
					...
				)
		end
	else
		return Current
	end
end

function VarArg.Map(Apply, ...)
	return VarArg.MapReduce(
		Apply, nil,
		...
	)
end

function VarArg.Reduce(Merge, ...)
	return VarArg.MapReduce(
		nil, Merge,
		...
	)
end

function VarArg.Concatenator(Seperator)
	local Seperated = "%s".. Seperator .."%s"
	return function(LHS, RHS)
		return Seperated:format(LHS, RHS)
	end
end

function VarArg.Concatenate(Seperator, ...)
	return VarArg.MapReduce(
		tostring, VarArg.Concatenator(Seperator),
		...
	)
end
VarArg.Concat = VarArg.Concatenate

return VarArg
