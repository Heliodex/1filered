local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Event = ReplicatedStorage:FindFirstChild "RedEvent"
local Promise = require "../Util/Promise"
local Serdes = {}

Serdes.NextId = 1 -- StringValues think null bytes are empty strings

function Serdes.RegisterIdentifier(Name: string)
	assert(_SERVER, "RegisterIdentifier can only be called on the server")

	local Id = string.char(Serdes.NextId)
	Serdes.NextId += 1

	local e = Event:FindFirstChild(Name)
	if e then
		e.Value = Id
	else
		e = Instance.new "StringValue"
		e.Name = Name
		e.Value = Id
		e.Parent = Event
	end

	print("-- registered identifier ", Name, "as", Id)

	return Id
end

function Serdes.Identifier(Name: string)
	if not Event then
		-- Prevent infinite yield when darklua bundling
		-- randomises the order of requires
		Event = ReplicatedStorage:WaitForChild "RedEvent"
	end

	local e
	if _CLIENT then
		return Promise.new(function(Resolve)
			e = Event:FindFirstChild(Name)
			local a = e.Value
			print("-- Client resolving", a)
			if a ~= nil then
				Resolve(a)
			else
				local Thread = task.delay(
					5,
					warn,
					"[Red.Serdes]: Retrieving identifier exceeded 5 seconds. Make sure '"
						.. Name
						.. "' is registered on the server."
				)

				e.Changed:Once(function()
					print "-- closing thread"
					coroutine.close(Thread)

					Resolve(e.Value)
				end)
			end
		end)
	else
		e = Event:FindFirstChild(Name)
		if e and e.Value then
			print("-- Server resolving", e.Value)
			return Promise.Resolve(e.Value)
		end
		return Promise.Resolve((Serdes.RegisterIdentifier(Name)))
	end
end

function Serdes.IdentifierAsync(Name: string)
	return Serdes.Identifier(Name):Await()
end

return Serdes
