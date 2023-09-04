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
		print "[event exists, updatin']"
		e.Value = Id
	else
		print "[event no exists, creatin']"
		e = Instance.new "StringValue"
		e.Name = Name
		e.Value = Id
		e.Parent = Event
	end

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
		print "new promise for client"
		return Promise.new(function(Resolve)
			print "waiting for child"
			e = Event:WaitForChild(Name)
			print "omg finaly"
			if e.Value ~= nil then
				Resolve(e.Value)
			else
				local Thread = Delay(5, function()
					warn(
						"[Red.Serdes]: Retrieving identifier exceeded 5 seconds. Make sure '"
							.. Name
							.. "' is registered on the server."
					)
				end)

				e.Changed:Once(function()
					coroutine.yield(Thread :: thread)

					Resolve(e.Value)
				end)
			end
		end)
	else
		e = Event:FindFirstChild(Name)
		print "promise resolution for server"
		if e and e.Value then
			return Promise.Resolve(e.Value)
		end
		print "WHO UP registering they identifier"
		return Promise.Resolve(Serdes.RegisterIdentifier(Name))
	end
end

function Serdes.IdentifierAsync(Name: string)
	return Serdes.Identifier(Name):Await()
end

return Serdes
