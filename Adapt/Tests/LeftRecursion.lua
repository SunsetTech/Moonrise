---@diagnostic disable:empty-block
unpack=unpack or table.unpack
require"Moonrise.Import.Install".All()

local CommandLine = require"Moonrise.Tools.CommandLine"
local Pretty = require"Moonrise.Tools.Pretty"
local Adapt = require"Moonrise.Adapt"
local TF = Adapt.Transform

local BasicFilters = require"Moonrise.Grammar.Filters"
local StringParser = require"Moonrise.Grammar.String"

local Left = require"Moonrise.Adapt.Transform.Left"

local function ComputeStack(Table, Reverse)
	local ValueIndex, NextIndex = "LHS", "RHS"
	if Reverse then
		ValueIndex, NextIndex = NextIndex, ValueIndex
	end
	local Stack = {}
	while type(Table) == "table" do
		table.insert(
			Stack, {Table[ValueIndex],Table.Op}
		)
		Table = Table[NextIndex]
	end
	table.insert(Stack, Table)
	return Stack
end

local function RightToLeft(Table)
	local Stack = ComputeStack(Table)
	--print(Pretty.Table(Stack,true,2))
	local Cur = {}
	local Head = Cur
	local Prev
	for Index = #Stack, 1, -1 do
		local Item = Stack[Index]
		if type(Item) == "table" then
			Item = Item[1]
		end
		local Op = (Stack[Index-1] or {})[2]
		if (Index ~= 1) then
			Cur.RHS = Item
			Cur.Op = Op
			Cur.LHS = {}
			Prev = Cur
			Cur = Cur.LHS
		else
			Prev.LHS = Item
		end
	end
	return Head
end

local function LeftToRight(Table)
	local Stack = ComputeStack(Table, true)
	local Cur = {}
	local Head = Cur
	local Prev
	for Index = #Stack, 1, -1 do
		local Item = Stack[Index]
		if type(Item) == "table" then
			Item = Item[1]
		end
		local Op = (Stack[Index-1] or {})[2]
		if (Index ~= 1) then
			Cur.LHS = Item
			Cur.Op = Op
			Cur.RHS = {}
			Prev = Cur
			Cur = Cur.RHS
		else
			Prev.RHS = Item
		end
	end
	return Head
end

--[[
---@type table<string, Adapt.Transform.Filter.Table>
local Filters = {
	Invert = {
		Raise = function(Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and RightToLeft(Result)
		end
	};
};]]

PatternB = TF.Grammar{
	Identifier = StringParser.Create(
		(TF.Bytes(1) - TF.String"+" - TF.String"\n")^1
	);
	Addition = Left(
		TF.Rule"Addition", TF.Rule"Identifier", 
		TF.String"+" * TF.Rule"Identifier"
	);
	(TF.Rule"Addition" + TF.Rule"Identifier")/BasicFilters.Select;
}

PatternA = TF.Grammar{
	Identifier = StringParser.Create(
		(
			TF.Bytes(1) 
			- (TF.Set"()+-\n")
		)^1
	);

	AddSub = TF.Grammar{
		RHS = (
			TF.Rule"AddSub" + TF.Rule"SubExpression" + TF.Rule"Identifier"
		)() /BasicFilters.Select;
		LHS = (TF.Rule"SubExpression" + TF.Rule"Identifier")/BasicFilters.Select;
		Operator = TF.Set"+-";
		(
			TF.Rule"LHS" * TF.Rule"Operator" * TF.Rule"RHS"
		)/BasicFilters.MapSequence{LHS=1,Op=2,RHS=3};
	};
	SubExpression=(TF.String"(" * TF.Rule"Expression" * TF.String")") /BasicFilters.MapSequence{Inner=2};
	Expression = ((TF.Rule"AddSub") + TF.Rule"SubExpression" + TF.Rule"Identifier") /BasicFilters.Select;
	TF.Rule"Expression"
}

local Options = CommandLine.GetOptions.Free()
local UseB = Options.Settings.pattern_b or Options.Settings.b
print(UseB)
local ReadBuffer = Adapt.Stream.File("./Tests/LeftRecurseInput", "rb")
local WriteBuffer = Adapt.Stream.File("./Tests/Output", "wb")

local Success, Result = Adapt.Process(UseB and PatternB or PatternA, "Raise", ReadBuffer, nil)
print(Pretty.Any(Result, true, 2))
--print(Pretty.Any(RightToLeft(Result),true,2))
--print(Adapt.Process(Pattern, "Lower", WriteBuffer, Result))
