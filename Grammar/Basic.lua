local TF = require"Moonrise.Adapt.Transform";

---@type table<string, Adapt.Transform.Base>
local Basic = {}

Basic.Anything = TF.Bytes(1);

Basic.EOF = TF.Dematch(
	Basic.Anything, 
	TF.Bytes(2)
);

Basic.Newline = TF.Select{
	TF.String"\r\n", 
	TF.String"\n"
};

Basic.Space = TF.String" ";

Basic.Tab = TF.String"\t"

Basic.Whitespace = TF.Select{
	Basic.Space,
	Basic.Tab,
	Basic.Newline
};

Basic.Number = TF.Range("0","9");

Basic.Letter = TF.Select{
	TF.Range("a","z"), 
	TF.Range("A","Z")
};

Basic.Alphanumeric = TF.Select{
	Basic.Letter, 
	Basic.Number
};

return Basic;
