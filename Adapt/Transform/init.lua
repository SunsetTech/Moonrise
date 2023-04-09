local Module = require"Moonrise.Import.Module"

return {
	Base = Module.Child"Base";
	Compound = Module.Child"Compound";
	Packed = Module.Child"Packed";
	Range = Module.Child"Range";
	String = Module.Child"String";
	Repeated = Module.Child"Repeated";
	Select = Module.Child"Select";
	Sequence = Module.Child"Sequence";
	Set = Module.Child"Set";
}
