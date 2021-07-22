local Module = require"Moonrise.Import.Module"

return {
	Env = Module.Child"Env";
	Filesystem = Module.Child"Filesystem";
	Process = Module.Child"Process";
	Shell = Module.Child"Shell";
}
