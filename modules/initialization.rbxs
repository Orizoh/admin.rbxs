--- This script handles initialization of admin.rbxs.
-- Information about admin.rbxs is available on its wiki (https://github.com/ROBLOX/admin.rbxs/wiki).
-- @release 0.1.1

local Players = Game:GetService('Players')

local main_package = shared["admin.rbxs"]
local notification_module = main_package.notification
local chat_module = main_package.chat

--- Verifies that configuration data sent to it is valid.
-- This is an attempt to provide useful feedback to users who make a mistake.
-- @param configuration A table tat represents configuration data for admin.rbxs.
local function verify_configuration(configuration)
	notification_module.assert_parameter("test_mode", configuration.test_mode, "boolean", true)
end

--- Initializes admin.rbxs for a specific player.
-- This function should not generally be called by external scripts or other modules, because all players who join the game will already be connected automatically.
-- @param player The player for which admin.rbxs should be initialized
function main_package:initialize_player(player)
	notification_module.assert(main_package.initialized, "admin.rbxs must be initialized globally before being initialized for individual players.")
	notification_module.assert_parameter("player", player, "Player")

	chat_module.listen_to_player(player)

	-- TODO: Give the admin.rbxs interface to the user, but only if he's in a group.
	-- What are we going to do if groups are edited after the user is initialized? Detect it dynamically and give him the interface?

	notification_module.message("admin.rbxs has been initialized for the player named \"" .. player.Name .. "\".")
end

--- Initializes admin.rbxs.
-- This function should not be called more than once. Its behavior becomes undefined after the first time it is called.
-- @param configuration This must be a table following the configuration table format. It must have no metatable. If it is not specified, the default configuration will be used.
-- @param initialize_players_manually If true, admin.rbxs will not initialize admin.rbxs for players automatically
function main_package:initialize(configuration, initialize_players_manually)
	notification_module.assert_parameter("configuration", configuration, "table", true)
	notification_module.assert_parameter("initialize_players_manually", initialize_players_manually, "boolean", true)

	if configuration ~= nil then
		verify_configuration(configuration) -- Verify that the table is valid.

		-- Change the configuration table's metatable index metamethod to point to the default configuration table, so undefined configuration items can fall back to the default.
		setmetatable(configuration, {__index = main_package.configuration})

		-- Replace the default configuration by this new configuration table.
		main_package.configuration = configuration
	end

	if initialize_players_manually then
		notification_module.message("admin.rbxs will need to be initialized manually for players.")
	else
		for _, player in next, Players:GetPlayers() do
			main_package:initialize_player(player)
		end

		notification_module.checkpoint("admin.rbxs was initialized for all the players currently connected.")

		Players.PlayerAdded:connect(function(player)
			main_package:initialize_player(player)
		end)
		notification_module.checkpoint("admin.rbxs will now be automatically initialized for players who enter the server.")
	end

	notification_module.checkpoint("admin.rbxs is initialized and ready to be used")
	main_package.initialized = true
end