local lanes = require"lanes"
local cqueues = require"cqueues"

local Tools = {
	Table = require"Moonrise.Tools.Table"
}

local OOP = require"Moonrise.OOP"

local Time = require"Moonrise.System.Posix.Time"

local Portal = OOP.Declarator.Shortcuts"Parallel.Portal"

function Portal:Initialize(Instance, Window)
	Instance.Window = Window or lanes.linda()
end

function Portal:Set(Key, Value)
	cqueues.sleep(0)
	return self.Window:set(Key, Value)
end

function Portal:Get(Key)
	cqueues.sleep(0)
	return self.Window:get(Key)
end

function Portal:Await(Key, Timeout)
	local StartTime, Value = Time.Wall()
	
	repeat
		cqueues.sleep(0)
		if Timeout and Time.Wall() - StartTime >= Timeout then
			return
		end
		Value = self:Get(Key)
	until Value
	
	return Value
end

function Portal:Send(Key, Value, Timeout)
	print(Key, Value, Timeout)
	cqueues.sleep(0)
	return self.Window:send(Timeout or 0, Key, Value)
end

function Portal:Receive(Key, Timeout, Batched, Min, Max)
	cqueues.sleep(0)
	if Batched then
		Min = Min or 1
		Max = Max or 0
		
		return self.Window:receive(
			Timeout or 0, Key, 
			self.Window.batched,
			Min, Max
		)
	else
		return self.Window:receive(Timeout or 0, Key)
	end
end

function Portal:SetChannel(Name, Channel)
	return self:Set("Channels.".. Name, Channel.Window)
end

function Portal:GetChannel(Name)
	return Portal(self:Get("Channels.".. Name))
end

function Portal:AwaitChannel(Name)
	return Portal(self:Await("Channels.".. Name))
end

function Portal:SetEventQueue(Name)
	self.Window:limit(Name, 2)
end

function Portal:Notify(Name, Type, Info)
	self:Send(
		Name, {
			Type = Type;
			Info = Info;
		}, 0
	)
end

local function PackResults(_, ...)
	return {...}
end

function Portal:CheckInbox(Name)
	return PackResults(self:Receive(Name, 0, true, 1))
end

function Portal:SendRequest(Tags, Info)
	Tags = Tools.Table.Copy(Tags)
	for _, Tag in pairs(Tags) do 
		Tags[Tag] = true
	end
	print"hhh"
	self:Send(
		"Requests", {
			Tags = Tags;
			Info = Info;
		}
	)
end

function Portal:GetRequests()
	return self:CheckInbox"Requests"
end

return Portal
