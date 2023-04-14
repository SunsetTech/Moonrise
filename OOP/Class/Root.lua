local Module = require"Moonrise.Import.Module"
local Tools = require"Moonrise.Tools"
--local Debug = require"Moonrise.Debug"

local Error = Tools.Error
local String = Tools.String
local Array = Tools.Array

local type = Tools.Inspect.Get.Type

local Create = Module.Relative"Create"
local Derive = Module.Relative"Derive"

local Unimplemented = Module.Sister"Unimplemented"

local function merge(stack,current)
	for i = #current.__inherits, 1, -1 do
		table.insert(stack, current.__inherits[i])
	end

end

local function depth_first_search(root, key)
	local stack = { root }

	while #stack > 0 do
		local current = table.remove(stack)

		if current.__members and current.__members[key] then
			return true, current.__members[key]
		end

		if current.__inherits then
			merge(stack, current)
			--[[for i = #current.__inherits, 1, -1 do
				table.insert(stack, current.__inherits[i])
			end]]
		end
	end

	return false
end

return Derive(
	"OOP.Class.Root", {
		Module.Sister"Constructor"
	},
	{
		__instantiate = function(self)
			local Instance, ID = Create(self)
			self:__register(Instance, ID)
			
			return Instance
		end;
		
		__register = function(self, Instance, ID)
			local InstanceInfo = {}
			self.__instanceinfo[Instance] = InstanceInfo
			InstanceInfo.ID = ID
		end;
		
		__index = function()
		end;
	},
	{
		__index = function(_, Derived)
			return function(LHS, Key)
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
							 (Value == nil or type(Value) == "OOP.Class.Unimplemented")
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
			
			for _, Inherit in pairs(Derived.__inherits) do
				local Name = Array.Last(String.Explode(Inherit.__type, "."))
				Parents[Name] = Parents[Name] or Inherit
			end
			
			return Parents
		end;
		
		__members = function(_,_)
			return {}
		end;
		
		__instanceinfo = function(_,_)
			return setmetatable({}, {__mode="k"})
		end;
		
		__tostring = function(_, Derived)
			return function(Instance)
				return Derived.__type ..": ".. Derived.__instanceinfo[Instance].ID:gsub("table: ","")
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
