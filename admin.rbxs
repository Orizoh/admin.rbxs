--- This script initializes other modules and assembles them into a main package that is then exported.
-- Information about admin.rbxs is available on its wiki (https://github.com/ROBLOX/admin.rbxs/wiki).
-- @release 0.1.1

-- Create a package table for holding all the modules; this package table will itself be a package.
local package = setmetatable({
	commands = {};
	version = "0.1.1";
	configuration = {};
	initialized = false
}, getmetatable(shared))

-- Export the package
shared["admin.rbxs"] = package

-- If this code is running in a script object, recursively enable all its descendants so all the modules run.
-- This is to make sure that modules will not run before this script itself runs.
if script ~= nil then
	local function recursively_enable_descendants(object)
		for _, child in next, object:GetChildren() do
			if child:IsA('Script') then
				child.Disabled = false
			end
			recursively_enable_descendants(child)
		end
	end

	recursively_enable_descendants(script)
end