local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Red = require(ReplicatedStorage.Red)

local Net = Red.Client "NamespaceName"

Net:On("EventName", function(...)
	print("Received:", ...)

	Net:Fire("EventName", "Guess who's back?")
	print("Sent:", "Guess who's back?")
end)

-- We first pass the event name, then the data to fire with
Net:Fire("EventName", "Hello, world!")
print("Sent:", "Hello, world!", "bruh 2")
