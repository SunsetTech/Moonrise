local posix = require("posix")

local Posix = {}

function Posix.Fork(ChildProcessFunction,ParentProcessFunction)
	local ChildPID = posix.fork()
	if (ChildPID == 0) then
		return ChildProcessFunction()
	else
		return ParentProcessFunction(ChildPID)
	end
end

function Posix.ReadAll(FD)
	local Buffer = ""
	while true do 
		local Characters = posix.read(FD,1024)
		if (#Characters == 0) then
			break
		else
			Buffer = Buffer .. Characters
		end
	end
	return Buffer
end

function Posix.BidirectionalOpen(Program,Arguments)
	local InputPipeR, InputPipeW = posix.pipe()
	local OutputPipeR, OutputPipeW = posix.pipe()
	return Posix.Fork(
		function()
			posix.close(InputPipeW)
			posix.close(OutputPipeR)
			posix.dup2(InputPipeR,posix.fileno(io.stdin))
			posix.dup2(OutputPipeW,posix.fileno(io.stdout))
			posix.exec(Program,unpack(Arguments or {}))
			posix.close(InputPipeR)
			posix.close(OutputPipeW)
			posix._exit(0)
		end,
		function(ChildPID)
			posix.close(InputPipeR)
			posix.close(OutputPipeW)
			return ChildPID,InputPipeW,OutputPipeR
		end
	)
end

function Posix.CallScriptFunction(ScriptPath,FunctionName,Arguments)
	return os.execute(
		([[source "%s"; %s %s]]):format(ScriptPath,FunctionName,table.concat(Arguments," "))
	)
end

return Posix
