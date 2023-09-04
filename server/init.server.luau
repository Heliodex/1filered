local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Red = require(ReplicatedStorage.Red)(script)

-- The typical variable name for a script's namespace is Net
local Net = Red.Server "NamespaceName"

Net:On("EventName", function(Player, i)
	print("Received from", Player.Name .. ":", i)

	Net:Fire(Player, "EventName", i + 1)
end)
