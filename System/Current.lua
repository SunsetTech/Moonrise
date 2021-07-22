local Module = require"Moonrise.Import.Module"
if pcall(require,"posix") then
	return Module.Sister"Posix"
end
