local Clock = require "Clock"

local DEFAULT_BASE = 10
local DEFAULT_SPEED = 3

return function (x, y, r, s, b)
	local self = {}
	x, y = x or 0, y or 0
	local clks = {}
	self.clks = clks
	local CLKS_MAX = 6
	local s = s or DEFAULT_SPEED
	local b = b or DEFAULT_BASE
	
	self.DEFAULT_BASE = DEFAULT_BASE
	self.DEFAULT_SPEED = DEFAULT_SPEED
	
	local UP, MD, RD, LD, RU, LU = 0.5, 3.75, 3.5, 9.5, 3, 9
	local ZU, ZR, ZD, ZL = 0, 3.25, 6.5, 9.75 
	local ZN = 8.68
	
	local poses = {}
		poses[0] = {RD, LD, UP, UP, RU, LU}
		poses[1] = {ZN, ZD, ZN, UP, ZN, ZU}
		poses[2] = {ZR, LD, RD, LU, RU, ZL}
		poses[3] = {ZR, LD, ZR, UP, ZR, LU}
		poses[4] = {ZD, ZD, RU, UP, ZN, UP}
		poses[5] = {RD, ZL, RU, LD, ZR, LU}
		poses[6] = {RD, ZL, RD, LD, RU, LU}
		poses[7] = {ZR, LD, ZN, UP, ZN, ZU}
		poses[8] = {RD, LD, RU, LU, RU, LU}
		poses[9] = {RD, LD, RU, UP, ZN, ZU}
	
	for i = 0, 2 do
		table.insert(clks, Clock(x, y, 0, i, r))
		table.insert(clks, Clock(x, y, 1, i, r))
	end

	function self:gotoDigit(n)
		for k, v in ipairs(clks) do
			v:gotoTime(poses[n][k], s)
		end
	end

	function self:tick(dt)
		for _, v in ipairs(clks) do v:tick(dt) end
	end
	
	function self:draw()
		for _, v in ipairs(clks) do v:draw() end
	end
	
	return self
end