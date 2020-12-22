local OOP = require"Toolbox.OOP2"

local PunctuationCache = {}
local CacheHits = 0
local function IncreaseCacheHits()
	CacheHits = CacheHits + 1
end

OOP.Define(
	"Punctuator",
	nil,
	{
		__initialize = function(self, LHS, Punctuation)
			LHS.Punctuation = Punctuation
		end;
		
		__mirror = function(self, LHS, RHS)
			self:__initialize(LHS, RHS.Punctuation)
		end;
		
		__eq = function(LHS, RHS)
			return LHS.Punctuation == RHS.Punctuation
		end;
		
		__members = {
			GetCacheHits = function()
				return CacheHits
			end;
			
			IncreaseCacheHits = IncreaseCacheHits;
			
			Punctuate = function(LHS, Message)
				local Punctuation = LHS.Punctuation
				local MessageCache = PunctuationCache[Punctuation]
				
				if not MessageCache then 
					MessageCache = {}
					PunctuationCache[Punctuation] = MessageCache
				end
				
				local Punctuated = MessageCache[Message]
				if not Punctuated then
					Punctuated = Message .. Punctuation
					MessageCache[Message] = Punctuated
				else
					IncreaseCacheHits()
				end
				
				return Punctuated
			end;
		};
	}
)
