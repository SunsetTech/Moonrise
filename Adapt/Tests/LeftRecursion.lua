local function TableToString(t, indent, seen)
	local Parts = {}
	for _,V in pairs(t) do
		if type(V) == "table" then
			table.insert(Parts, _ ..": ".. TableToString(V))
		else
			table.insert(Parts, _ ..": ".. tostring(V))
		end
	end
	return "{"..table.concat(Parts,", ").."}"
end

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


unpack=unpack or table.unpack
require"Moonrise.Import.Install".All()

local Adapt = require"Moonrise.Adapt"
local TF = Adapt.Transform

Raise = {
	SequenceToAST = function(Recurse, Argument)
		local Success, Result = Recurse(Argument)
		if Result then
			Result = {LHS = Result[1], Op = Result[2], RHS = Result[3]}
		end
		return Success, Result
	end;
	Invert = function(Recurse, Argument)
		local Success, Result = Recurse(Argument)
		return Success, Success and RightToLeft(Result)
	end;
	SelectToAST = function(Recurse, Argument)
		local Success, Result = Recurse(Argument)
		return Success, Result[Result.__which]
	end;
}

Lower = {
	SequenceToAST = function(Recurse, Argument)
		--print(TableToString(Argument))
		local Arg = {
			Argument.LHS,
			Argument.Op,
			Argument.RHS
		}
		return Recurse(Arg)
	end;
	Invert = function (Recurse,Argument)
		return Recurse(LeftToRight(Argument))
	end;
	SelectToAST = function(Recurse, Argument)
		if (type(Argument) == "table") then
			Argument = {[1]=Argument, __which=1}
		else
			Argument = {[2]=Argument, __which=2}
		end
		return Recurse(Argument)
	end;
}

Pattern = TF.Grammar{--TODO handle not an operation case?
	Character = TF.Dematch(TF.Bytes(1),TF.String"\n");
	RHS = TF.Filter(
		TF.Expect(
			TF.Select{
				TF.Jump"Test",
				TF.Jump"Character"	
			}
		),Raise.SelectToAST, Lower.SelectToAST
	);
	Test = TF.Filter(
		TF.Sequence{
			TF.Jump"Character",
			TF.String"+",
			TF.Jump"RHS"
		},
		Raise.SequenceToAST, Lower.SequenceToAST
	);
	TF.Select{
		TF.Filter(
			TF.Jump"Test",
			Raise.Invert, Lower.Invert
		),
		TF.Jump"Character"
	}
}
local ReadBuffer = Adapt.Stream.File("./Tests/LeftRecurseInput", "rb")
local WriteBuffer = Adapt.Stream.File("./Tests/Output", "wb")

local Success, Result = Adapt.Process(Pattern, "Raise", ReadBuffer, nil)
print(Adapt.Process(Pattern, "Lower", WriteBuffer, Result))
