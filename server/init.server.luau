local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Red = require(ReplicatedStorage.Red)
if type(Red) == "function" then
	Red = Red(script)
end

local x = 0

Red.Clock.new(0.5, function()
	print((x % 2 == 0) and "tock" or "tick,")
	x = x + 1
end)
