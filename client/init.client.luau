local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Red = require(ReplicatedStorage.Red)(script)

local Net = Red.Client "NamespaceName"
Net:Call("Add", 1, 2):Then(function(Result)
	print(Result) -- 3
end)
