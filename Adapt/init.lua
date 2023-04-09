local Module = require"Moonrise.Import.Module"

local Adapt; Adapt = {
	Stream = Module.Child"Stream";
	Transform = Module.Child"Transform";
	Execution = Module.Child"Execution";
	
	Process = function(Node, MethodName, Buffer, ...)
		local ExecutionState = Adapt.Execution.State(Buffer)
		
		return Adapt.Execution.Recurse(
			ExecutionState, 
			MethodName, "Root", 
			Node, ...
		)
	end;
}; return Adapt;
