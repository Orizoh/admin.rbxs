--- This script handles notifications for admin.rbxs. It sends them to the interfaces and prints them in the game output.
-- This module is one of the first to run because many other modules depend on its functionality.
-- Information about admin.rbxs is available on its wiki (https://github.com/ROBLOX/admin.rbxs/wiki).
-- @release 0.1.1

local TestService = Game:GetService('TestService')

local main_package = shared["admin.rbxs"]
local type_library = shared.type_library
local module = {}

--- Returns the script object of the thread that called this function. If not available, returns nil.
-- This function may return an invalid result if called by a script whose environment's 'script' variable was changed to refer to another script object.
local function get_call_source()
	local possible_source = getfenv(0).script
	local _, result = pcall(Game.IsA, possible_source, 'Script')
	if result == true then
		return possible_source
	end
end

--- Returns the line number at which a certain call in the call stack happened
-- A level of 0 will return the line number at which get_call_line_number was called.
-- A level of 1 will return the line number at which the function that called get_call_line_number was called.
-- @param level The level in the call stack. If not specified, 1.
local function get_call_line_number(level)
	return select(2, pcall(error, "", (level or 1) + 3)):match(":(%d+):")
end

--- Returns a prefix for outgoing messages.
-- A level of 0 will return a prefix for messages initiated where get_message_prefix was called.
-- A level of 1 will return a prefix for messages initiated where the function that called get_message_prefix was called.
-- @param level The level in the call stack at which the message was initiated. If not specified, 1.
local function get_message_prefix(level)
	local source = get_call_source()
	local call_line_number = get_call_line_number((level or 1) + 1)
	return (source and source:GetFullName() .. ":" or "") .. (call_line_number and call_line_number .. ":" or "")
end

--- Sends a notification about a specific checkpoint being reached.
-- Specific checkpoints are generally never sent notification about more than once.
-- They generally correspond to particular moments in the initialization of the script.
-- @param description A description of the checkpoint
function module.checkpoint(description)
	if main_package.configuration.test_mode then
		TestService:Checkpoint(description, get_call_source(), get_call_line_number())
	else
		print(get_message_prefix(), description)
	end
end

--- Sends a warning to the user accordingly to the configuration if a condition is false.
-- @param description The message to send as a warning
-- @param condition If present, the message will only be sent if this condition is false.
function module.warn(description, condition)
	if main_package.configuration.test_mode then
		TestService:Warn(condition, description, get_call_source(), get_call_line_number())
	elseif not condition then
		print(get_message_prefix(), description)
	end
end

--- Verifies that the given assertion is true. If it is not, behave accordingly to the configuration.
-- A level of 1 will represent an assertion made in the function that called assert.
-- A level of 2 will represent an assertion made in the function that called the function that called assert.
-- @param assertion A condition representing an assertion.
-- @param description A description of the assertion
-- @param level The stack level at which the assertion is made. Will be 1 by default.
function module.assert(assertion, description, level)
	if main_package.configuration.test_mode then
		TestService:Check(assertion, description, get_call_source(), get_call_line_number())
	elseif not assertion then
		print(get_message_prefix())
	end
end

--- Verifies that the value given to it is valid. If it is not, behave accordingly to the configuration.
-- @param identifier The name to give to the argument in the error message. If a number, the number of the parameter in the parameter list. If a string, the name of the parameter.
-- @param value The value of the parameter.
-- @param verify A function that returns true when given a value as an argument if the value is valid. Can also be a string that represents a type. Can also be an enum, in which case the value will be considered valid if it is an enum item that belongs to that enum.
-- @param optional If true, the value nil will be considered as valid.
function module.assert_parameter(identifier, value, verify, optional)
	type_library.assert_parameter(identifier, value, verify, optional, 1, module.assert)
end

main_package.notification = module