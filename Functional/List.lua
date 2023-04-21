local List; List = {
	Count = function(...)
		return select('#', ...)
	end;
	
	Forwards = function(First, ...)
		coroutine.yield(First)
		
		if List.Count(...) > 0 then
			List.Forwards(...)
		end
	end;
	
	Backwards = function(Last, ...)
		if List.Count(...) > 0 then
			List.Backwards(...)
		end
		
		coroutine.yield(Last)
	end;
	
	Mix = function(Apply, Merge, Current, ...)
		if Apply then
			Current = Apply(Current)
		end
		
		if List.Count(...) > 0 then
			if Merge then
				return Merge(
					Current,
					List.Mix(
						Apply, Merge,
						...
					)
				)
			else
				return 
					Current,
					List.Mix(
						Apply, Merge,
						...
					)
			end
		else
			return Current
		end
	end;
	
	Map = function(Apply, ...)
		return List.Mix(
			Apply, nil,
			...
		)
	end;
	
	Reduce = function(Merge, ...)
		return List.Mix(
			nil, Merge,
			...
		)
	end;
	
	Seperator = function(Character)
		return function(LHS, RHS)
			return LHS .. Character .. RHS
		end
	end;
	
	Concatenate = function(Character, ...)
		return List.Mix(
			tostring, List.Seperator(Character),
			...
		)
	end;
	
	Join = function(...)
		return List.Concatenate("", ...)
	end;
	
	Bounce = function(...)
		return coroutine.yield(), List.Bounce(coroutine.yield(...))
	end;
	
	Stash = function(...)
		local Trampoline = coroutine.wrap(List.Bounce)
		Trampoline(...)
		return Trampoline
	end;
}

return List
