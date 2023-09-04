local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Red = require(ReplicatedStorage.Red)(script)

local Net = Red.Client "NamespaceName"

Net:On("EventName", function(i)
	print("Received from server:", i)

	if i < 4 then
		Net:Fire("EventName", i + 1)
	end
end)

-- We first pass the event name, then the data to fire with
Net:Fire("EventName", 0)
print "Sent initial event"
