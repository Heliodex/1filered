local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Red = require(ReplicatedStorage.Red)(script)

local Net = Red.Client "NamespaceName"

Net:On("EventName", function(...)
	print("Received from server:", ...)

	Net:Fire("EventName", "Guess who's back?")
	print("Sent back to server:", "Guess who's back?")
end)

-- We first pass the event name, then the data to fire with
Net:Fire("EventName", "Hello, world!")
print("Sent to server:", "Hello, world!", "bruh 2")
