local Digit = require "Digit"

local DEFAULT_R = 5
local DEFAULT_W = 1
local DEFAULT_SEP = 5
local DEFAULT_SPEED = 3

return function(x, y, r, w, sep, s)
	local self = {}
	x, y = x or 0, y or 0
	r = r or DEFAULT_R
	w = w or DEFAULT_W
	sep = sep or DEFAULT_SEP
	s = s or DEFAULT_SPEED
	
	self.DEFAULT_R = DEFAULT_R
	self.DEFAULT_W = DEFAULT_W
	self.DEFAULT_SEP = DEFAULT_SEP
	self.DEFAULT_SPEED = DEFAULT_SPEED
		
	local digits = {}
	self.digits = digits
	
	for i = 1, w do
		local dx = x + ((i - 1) * r * 4) + ((i - 1) * sep)
		table.insert(digits, Digit(dx, y, r, s))
	end
	
	function self:gotoNumber(n)
		s = tostring(n)
		if s:find("%.") then error "Number must be an integer." end
		if s:len() > w then error("Number must be no wider than " .. w) end
		while s:len() < w do
			s = '0' .. n
		end
		
		for i = 1, w do
			digits[i]:gotoDigit(tonumber(s:sub(i, i)))
		end
	end
	
	function self:getTopRightEdge()
		return r * 4 * w + ((w - 1) * sep), y -- return x + width, y
	end
	
	function self:tick(dt)
		for _, v in ipairs(digits) do v:tick(dt) end
	end
	
	function self:draw()
		for _, v in ipairs(digits) do v:draw() end
	end
	
	return self
end