--- This script listens for chat messages, interprets those that look like commands, and sends them to the action module.
-- Information about admin.rbxs is available on its wiki (https://github.com/ROBLOX/admin.rbxs/wiki).
-- @release 0.1.1

local main_package = shared["admin.rbxs"]
local notification_module = main_package.notification
local module = {}

function module.listen_to_player(player)
	notification_module.assert_parameter("player", player, "Player")

	player.Chatted:connect(function(message)
		-- TODO: check if the message is a command; if it is, separate the command and the parameters and send them to the action module
	end)

	notification_module.message("The chat module is now listening to " .. player.Name .. ".")
end

main_package.chat = module