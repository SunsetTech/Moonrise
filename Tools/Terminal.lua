local Terminal; Terminal = {
	Style = {
		Set={
			Bold=1;
			Dim=2;
			Italic=3;
			Underline=4;
			Blinking=5;
			Inverse=7;
			Hidden=8;
			Strikethrough=9;
		};
		Reset = {
			All = 0;
			Bold=21;
			Dim=22;
			Italic=23;
			Underline=24;
			Blinking=25;
			Inverse=27;
			Hidden=28;
			Strikethrough=29;
		};
	};
	Color = {
		FG = {
			Black = 30;
			Red = 31;
			Green = 32;
			Yellow = 33;
			Blue = 34;
			Magenta = 35;
			Cyan = 36;
			White = 37;
			Default = 39;
		};
		BG = {
			Black = 40;
			Red = 41;
			Green = 42;
			Yellow = 43;
			Blue = 44;
			Magenta = 45;
			Cyan = 46;
			White = 47;
			Default = 49;
		};
	};
	Format = function (String, StyleCodes, NoReset)
		local StyleCodeStrings = {}
		for _, StyleCode in pairs(StyleCodes) do
			table.insert(StyleCodeStrings, tostring(StyleCode))
		end
		
		return "\x1b[".. table.concat(StyleCodeStrings, ";") .."m".. String ..(NoReset and "" or "\x1b[0m")
	end
}; return Terminal;
