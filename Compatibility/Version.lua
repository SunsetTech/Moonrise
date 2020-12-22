local _MAJOR, _MINOR = _VERSION:match"Lua (%d+)%.(%d+)"
local Current = {
	Major = tonumber(_MAJOR);
	Minor = tonumber(_MINOR);
}

local Version = {}

function Version.Atleast(Major, Minor)
	return Current.Major >= Major and Current.Minor >= Minor
end

return Version
