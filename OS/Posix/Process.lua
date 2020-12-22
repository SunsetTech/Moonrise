local posix = require("posix")

local Process; Process = {
	Fork = function(Child, Parent)
		local PID = posix.fork()
		if (PID == 0) then
			return Child(PID)
		else
			return Parent(PID)
		end
	end;
	
	Pipe = function()
		local Read, Write = posix.pipe()
		return {
			Read = Read;
			Write = Write;
		}
	end;
	
	Open = function(Program, Arguments)
		Child = {
			In = Process.Pipe();
			Out = Process.Pipe();
		}
		
		return Package.Fork(
			function(PID)
				posix.close(Child.Out.Read)
				posix.dup2(
					Child.In.Read,
					posix.fileno(io.stdin)
				)
				
				posix.close(Child.In.Write)
				posix.dup2(
					Child.Out.Write,
					posix.fileno(io.stdout)
				)
				
				posix.exec(
					Program,
					unpack(Arguments or {})
				)
				--never reached?
				posix.close(Child.In.Read)
				posix.close(Child.Out.Write)
				
				posix._exit(Code)
			end,
			function(PID)
				posix.close(Child.In.Read)
				posix.close(Child.Out.Write)
				return PID, Child.In.Write, Child.Out.Read
			end
		)
	end
	
	-[=[function Package.CallScriptFunction(ScriptPath,FunctionName,Arguments)
		return os.execute(
			([[source "%s"; %s %s]]):format(ScriptPath,FunctionName,table.concat(Arguments," "))
		)
	end]=]
}

return Process
