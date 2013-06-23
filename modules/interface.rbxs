--- This script creates a class that can be used to create user interfaces for using admin.rbxs and serves as a hook between these interfaces and the action module.
-- Information about admin.rbxs is available on its wiki (https://github.com/ROBLOX/admin.rbxs/wiki).
-- @release 0.1.1

local main_package = shared["admin.rbxs"]
local class = shared.class
local Widget = shared.Widget

local Interface = class(Widget)
do
	Interface._name = "Interface"

	--- Creates a new user interface for using admin.rbxs.
	function Interface:_init(parent)
		self:super("admin.rbxs", parent)

		self.Active = true
		self.BackgroundColor3 = Color3.new(0, 0, 0)
		self.BackgroundTransparency = 0.75
		self.interface.BorderSizePixel = 0
		self.interface.Draggable = true
		self.interface.Size = UDim2.new(0.5, 0, 0.5, 0)
	end
end

main_package.Interface = Interface