local Array = {}

function Array.Last(In)
	return In[#In]
end

function Array.FindMatch(ArrayA,ArrayB,StartA,StartB)
	StartA = StartA or 1
	StartB = StartB or 1
	local Match = {}
	for AIndex = StartA,#ArrayA do
		local AItem = ArrayA[AIndex]
		local BItem = ArrayB[StartB+(AIndex-1)]
		if (AItem == BItem) then
			table.insert(Match,AItem)
		else
			break
		end
	end
	return Match
end

function Array.FindSequence(In,What)
	local Indexes = {}
	local Stride = #What-1
	if (#In >= #What) then
		for Index = 1, #In-Stride do
			local SliceMatches = true
			for Offset = 1, Stride do
				if (In[Index+(Offset-1)] ~= What[Offset]) then
					SliceMatches = false
					break
				end
			end
			if (SliceMatches) then
				table.insert(Indexes,Index)
			end
		end
	end
	return Indexes
end

---Constructs a new array which is the reverse of Source
---@param Source table
---@return table
function Array.Reverse(Source)
	local Result = {}
	
	for _,Value in pairs(Source) do
		table.insert(Result,1,Value)
	end
	
	return Result
end

---comment
---@param Source any[]
---@param From integer
---@param To integer
---@return any[]
function Array.Slice(Source,From,To)
	From = From or 1
	To = To or #Source

	local Result = {}
	
	for i = From,To do
		table.insert(Result,Source[i])
	end
	
	return Result
end

---@param Sources any[][]
---@return any[]
function Array.Concat(Sources)
	local Merged = {}
	for _,Source in pairs(Sources) do
		for _,Value in pairs(Source) do
			table.insert(Merged,Value)
		end
	end
	return Merged
end

function Array.Zip(Zipper,Over,Iterator,State)
	repeat
		State, Link = Iterator(State)
		if Link then
			Over = Zipper(Over,Link)
		end
	until State == nil
	return Over
end

return Array
