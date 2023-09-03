local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Red = require(ReplicatedStorage.Red)(script)

-- The typical variable name for a script's namespace is Net
local Net = Red.Server "NamespaceName"

Net:On("EventName", function(Player, ...)
	print("Received from", Player.Name .. ":", ...)

	Net:Fire(Player, "EventName", "Back to you!")
	print("Sent back to client:", "Back to you!")
end)
