local Version = {}

function Version.Is(Suffix)
	return _VERSION == "Lua ".. Suffix
end

return Version
