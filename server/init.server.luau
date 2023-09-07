local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Red = require(ReplicatedStorage.Red)(script)

local Net = Red.Server "NamespaceName"
Net:On("Add", function(_, A, B)
	return A + B
end)
