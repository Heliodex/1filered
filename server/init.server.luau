local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Red = require(ReplicatedStorage.Red)

-- The typical variable name for a script's namespace is Net
local Net = Red.Server "NamespaceName"

Net:On("EventName", function(Player, ...)
	print(Player, "sent:", ...)

	Net:Fire(Player, "EventName", "Back to you!")
	print("Sent back:", "Back to you!")
end)
