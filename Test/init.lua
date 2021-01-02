local Test = {}

function Test.Results(Name, Passed, Tasks)
	return {
		Name = Name;
		Passed = Passed;
		Tasks = Tasks;
	}
end

function Test.Passes(Name, Method)
	return function(...)
		local Passed, Data = Method(...)
		return Test.Results("+".. Name, Passed, Data)
	end
end

function Test.Fails(Name, Method)
	return function(...)
		local Passed, Data = Method(...)
		return Test.Results("~".. Name, not Passed, Data)
	end
end

function Test.Series(Name, Tasks)
	return function(Arguments)
		Arguments = Arguments or {}
		local Data, AllPassed = {}, true
		for Index, Task in pairs(Tasks) do
			Data[Index] = Task(table.unpack(Arguments[Index] or {}))
			AllPassed = AllPassed and Data[Index].Passed
		end
		return Test.Results(Name, AllPassed, Data)
	end
end

local Indent = 0

function Test.Print(Results, Indent, Last)
	Indent = Indent or 0
	io.write(string.rep("| ", Indent-1), Indent > 0 and "|_" or "", Results.Name, "[", Results.Passed and "Passed" or "Failed", "]\n")
	if Results.Tasks then
		for Index, Task in pairs(Results.Tasks) do
			Test.Print(Task, Indent + 1, Index == #Results.Tasks)
		end
	end
end

function Test.Pass() return true  end
function Test.Fail() return false end

Test.Print(
	Test.Series(
		"All", {
			Test.Series(
				"Pass", {
					Test.Passes("1", Test.Pass);
					Test.Passes("2", Test.Pass);
				}
			);
			Test.Series(
				"Fail", {
					Test.Fails("1", Test.Fail);
					Test.Fails("2", Test.Fail);
				}
			);
			Test.Series(
				"Mixed", {
					Test.Passes("1", Test.Pass);
					Test.Fails("2", Test.Fail);
				}
			)
		}
	)()
)

return Test
