math.randomseed(os.time()) --TODO remove me
local Module = require"Moonrise.Import.Module"
--local Tools = require"Moonrise.Tools"
--local Debug = require"Moonrise.Debug"

local Error = require"Moonrise.Tools.Error"
local String = require"Moonrise.Tools.String"
local Array = require"Moonrise.Tools.Array"

local type = require"Moonrise.Tools.Inspect".Get.Type

local Create = Module.Relative"Create"
local Derive = Module.Relative"Derive"

local Unimplemented = Module.Sister"Unimplemented"

local Count = {}

local function colorize_string(input)
    -- Generate a random 24-bit color
    local r = math.random(0, 255)
    local g = math.random(0, 255)
    local b = math.random(0, 255)

    -- Create an ANSI escape code to set the terminal foreground color
    local ansi_code = string.format("\27[38;2;%d;%d;%dm", r, g, b)

    -- Wrap the input string with the generated color and reset code
    local colorized = ansi_code .. input .. "\27[0m"

    return colorized
end

return Derive(
	"OOP.Class.Root", {
		Module.Sister"Constructor"
	},
	{
		__instantiate = function(self,...)
			--print(...)
			local Instance, ID = Create(self)
			self:__register(Instance, ID)
			self:__initialize(Instance,...)	
			return Instance
		end;
		
		__register = function(self, Instance, ID)
			--local InstanceInfo = {}
			self.__instanceinfo[Instance] = colorize_string(ID:gsub("table: ",""))
			--InstanceInfo.ID = ID
		end;
		
		__index = function()
		end;
	},
	{
		__index = function(_, Derived)
			return function(LHS, Key)
				--assert(Key ~= "Copy", Derived.__type)
				--[[Count[Derived.__type] = Count[Derived.__type] or {}
				Count[Derived.__type][Key] = (Count[Derived.__type][Key] or 0) + 1
				print(Derived.__type, Key, Count[Derived.__type][Key])]]
				local Value = Derived.__members[Key]
				
				--[=[if type(Value) == "function" then
					local TraceInfo = Derived.__trace
					
					---@diagnostic disable-next-line:empty-block
					if	TraceInfo.enabled
					and (
							 (TraceInfo.filter == "follow" and		 TraceInfo.follow[Key])
						or (TraceInfo.filter == "skip"	 and not TraceInfo.skip	[Key])
					) 
					then
						--[[return Debug.Wrap(
							Derived.__type ..".".. Key, Value,
							TraceInfo.shallow[Key] or false,
							TraceInfo.Enter, TraceInfo.Exit
						)]]
					end
				elseif type(Value) ~= "OOP.Class.Unimplemented" then]=]
					local Inherits = Derived.__inherits
					local Index, Length = 1, #Inherits
					
					while 
							 (Value == nil --[[or type(Value) == "OOP.Class.Unimplemented"]])
						and Index <= Length 
					do

						Value = Inherits[Index].__index(LHS, Key)
						Index = Index + 1
					end
				--end
				
				return Value --or Unimplemented(tostring(LHS), Key)
			end
		end;
		
		__copy = function(_, Derived)
			return function(RHS)
				local LHS = Derived:__instantiate()
					Derived:__mirror(LHS, RHS)
				return LHS
			end
		end;
		
		__parents = function(_, Derived)
			local Parents = {}
			
			--for _, Inherit in pairs(Derived.__inherits) do
			for Index = 1, #Derived.__inherits do
				local Inherit = Derived.__inherits[Index]
				local Name = Array.Last(String.Explode(Inherit.__type, "."))
				Parents[Name] = Parents[Name] or Inherit
			end
			
			return Parents
		end;
		
		__members = function(_,_)
			return {}
		end;
		
		__instanceinfo = function(_,_)
			InfoTable = setmetatable({}, {__mode="k"})
			return InfoTable
		end;
		
		__tostring = function(_, Derived)
			return function(Instance)
				--return Derived.__type ..": ".. (Derived.__instanceinfo[Instance] or "(ID Disabled)")
				return (Derived.__instanceinfo[Instance]):gsub("0x",Derived.__type ..": 0x")
			end
		end;
		
		__trace = function(_, Derived)
			return {
				enabled = false;
				filter = "skip";
				follow = {};
				skip = {};
				shallow = {};
			}
		end
	},
	Module.Sister"Linker"
)
