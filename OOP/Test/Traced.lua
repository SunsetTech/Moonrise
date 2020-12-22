require"Toolbox.Import.Install".All()
local OOP = require"Toolbox.OOP"

local Class = OOP.Declarator.Shortcuts"Class"

function Class:Add(A)
	return A+A
end

function Class:Multiply(A)
	return A*A
end

function Class:MultiplyAndAdd(A)
	return self:Add(
		self:Multiply(A)
	)
end

function Class:Power(A)
	return A^A
end

function Class:Test(A)
	return self:MultiplyAndAdd(
		self:Power(A)
	)
end

local TraceInfo = Class.__trace
TraceInfo.enabled = true
TraceInfo.shallow = {
	Add = true;
	Multiply = true;
	Power = true;
}

local Instance = Class()
for i = 1,3 do
	Instance:Test(i)
end
