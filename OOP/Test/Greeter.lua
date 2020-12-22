local Module = require"Toolbox.Import.Module"
local OOP = require"Toolbox.OOP2"

local Greeter, Members, Private, Parents, Punctuator = 
	OOP.Define(
		"Greeter", { 
			Module.Sister"Punctuator"
		}
	)

local CacheHits = 0

local InitializePunctuator = Punctuator.__initialize
function Greeter:__initialize(Instance, Greeting, Punctuation)
		InitializePunctuator(Punctuator, Instance, Punctuation)
		--Punctuator:__initialize(Instance, Punctuation)
	--Private[Instance].Greeting = Greeting
	Instance.Greeting = Greeting
end


function Greeter.__members:GetGreeting()
	return self.Greeting
end

local Punctuate = Punctuator.__members.Punctuate
local IncreaseCacheHits = Punctuator.__members.IncreaseCacheHits
local PunctuationCache = {}

function Members:Greet(Name)
	--local Private = Private[self]
	local Greeting = self.Greeting
	local Punctuation = self.Punctuation
	
	local GreetingCache = PunctuationCache[Punctuation]
	if not GreetingCache then
		GreetingCache = {}
		PunctuationCache[Punctuation] = GreetingCache
	end
	
	local NameCache = GreetingCache[Name]
	if not NameCache then
		NameCache = {}
		GreetingCache[Name] = NameCache
	end

	local Greeted = NameCache[Name]
	if not Greeted then
		Greeted = Greeting:format(Punctuate(self, Name))
		NameCache[Name] = Greeted
	end
	
	return Greeted
end

function Greeter:__mirror(To, From)
	Greeter:__initialize(To, From.Greeting, From.Punctuation)
end

function Greeter:__eq(To)
	return Punctuator.__eq(self, To) and self.Greeting == To.Greeting
end

return Greeter
