local function SetValue(In, Key, Value)
	Key = Key:lower()
	if In[Key] then
		if (type(In[Key]) == "table") then
			table.insert(In[Key], Value)
		else
			In[Key] = {In[Key], Value}
		end
	else
		In[Key] = Value
	end
end

local CommandLine; CommandLine = {
	GetOptions = function()
		local Grammar = require"Moonrise.Grammar.CommandLine"
		local Process = require"Moonrise.Adapt.Process"
		local StringStream = require"Moonrise.Adapt.Stream.String"
		local Results = {
			Settings = {};
			Arguments = {};
		}
		for Index = 1, #arg do
			local Success, Result = Process(Grammar, "Raise", StringStream(arg[Index]))
			if Success then
				local Keys, Value = Result.Key, Result.Value
				if type(Keys) == "table" then
					for _, Key in pairs(Keys) do
						SetValue(Results.Settings, Key, Value or true)
					end
				else
					SetValue(Results.Settings, Keys, Value or true)
				end
			else
				table.insert(Results.Arguments, arg[Index])
			end
		end
		return Results
	end;
}; return CommandLine;
