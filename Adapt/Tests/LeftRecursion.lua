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
		table.insert(Stack, {Table[ValueIndex],Table.Op})
		Table = Table[NextIndex]
	end
	table.insert(Stack, Table)
	return Stack
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
	print(Pretty.Table(Head,true,2))
	return Head
end

---@type table<string, Adapt.Transform.Filter.Table>
local Filters = {
	Swap = {
		Raise = function (Recurse, Argument)
			local Success, Result = Recurse(Argument)
			if Success then
				return Success, function(LHS)
					return {
					}
				end
				--[[
				return Success, {
					LHS = {
						LHS = Result.LHS;
						Op = Result.Op;
						RHS = Result.RHS.LHS
					};
					Op = Result.RHS.Op;
					RHS = Result.RHS.RHS;
				}]]
			end
			return Success, Result
		end
	};
	Invert = {
		Raise = function(Recurse, Argument)
			local Success, Result = Recurse(Argument)
			return Success, Success and RightToLeft(Result)
		end
	};
};

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

PatternA = TF.Grammar{--TODO handle not an operation case?
	IgnoreSet = TF.String" " + TF.String"\n";
	IgnoreSetAll = TF.Rule"IgnoreSet"^0;
	Identifier = StringParser.Create(
		(
			TF.Bytes(1) 
			- (TF.String"+" + TF.Rule"IgnoreSet")
		)^1
	);
	RHS = (TF.Rule"Addition" + TF.Rule"Identifier")() /BasicFilters.Select;
	Addition = (
		TF.Rule"Identifier" * TF.Rule"IgnoreSetAll" * TF.String"+" * TF.Rule"IgnoreSetAll" * TF.Rule"RHS"
	) /BasicFilters.NamedSequence{LHS=1,Op=3,RHS=5}/BasicFilters.Debug"Addition.Before-Swap";
	(TF.Rule"Addition" + TF.Rule"Identifier") /BasicFilters.Select;
}

local Options = CommandLine.GetOptions.Free()
local UseB = Options.Settings.pattern_b or Options.Settings.b
print(UseB)
local ReadBuffer = Adapt.Stream.File("./Tests/LeftRecurseInput", "rb")
local WriteBuffer = Adapt.Stream.File("./Tests/Output", "wb")

local Success, Result = Adapt.Process(UseB and PatternB or PatternA, "Raise", ReadBuffer, nil)
print(Pretty.Any(Result, true, 2))
--print(Adapt.Process(Pattern, "Lower", WriteBuffer, Result))
