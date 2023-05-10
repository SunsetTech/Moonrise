local Error; Error = {
	Location = function(At, Offset)
		return (At or 1) + Offset
	end;
	
	Here = {
		Location = function(At)
			return Error.Location(At, 1)
		end;
		
		Throw = function(Message, At)
			error(
				Message, 
				Error.Here.Location(At)
			)
		end;
		
		Assert = function(Passed, Message, At)
			if not Passed then
				Error.Here.Throw(
					Message, 
					Error.Here.Location(At)
				)
			end
		end;
		
		Test = function(At, Succeeded, ...)
			if Succeeded then
				return ...
			else
				local Message = ...
				Error.Here.Throw(
					Message,
					Error.Here.Location(At)
				)
			end
		end;
	};
	
	Caller = {
		Location = function(At)
			return Error.Location(At, 2)
		end;
		
		Throw = function(Message, At)
			Error.Here.Throw(
				Message, 
				Error.Caller.Location(At)
			)
		end;
		
		Wrap = function(Function, At)
			return function(...)
				--[[return Error.Here.Test(
					Error.Here.Location(At),
					pcall(Function, ...)
				)]]
				return Function(...)
			end
		end;
		
		Assert = function(Passed, Message, At)
			Error.Here.Assert(
				Passed, Message, 
				Error.Caller.Location(At)
			)
		end;
		
		Unimplemented = function()
			Error.Caller.Throw"Function not implemented"
		end;
	};
}

Error.Assert = Error.Here.Assert
Error.CallerError = Error.Caller.Throw
Error.CallerAssert = Error.Caller.Assert
Error.NotImplemented = Error.Caller.Unimplemented
Error.Rethrow = Error.Caller.Rethrow

function Error.NotMine(Function, ...)
	return Function(...)
	--return Error.Caller.Wrap(Function)(...)
end

return Error
