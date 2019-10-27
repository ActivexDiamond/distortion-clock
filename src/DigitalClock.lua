local Number = require "Number"

local DEFAULT_R = 5
local DEFAULT_SPEED_MULT = 1
local DEFAULT_SEP = 25

return function(x, y, r, sep, speed)
	local self = {}
	x, y = x or 0, y or 0
	r = r or DEFAULT_R
	sep = sep or DEFAULT_SEP
	speed = speed or DEFAULT_SPEED_MULT
	local sepSprs = {}
	local preDrawShader = {}
	local postDrawShader = {} 
	
	self.DEFAULT_R = DEFAULT_R
	self.DEFAULT_SPEED_MULT = DEFAULT_SPEED_MULT
	self.DEFAULT_SEP = DEFAULT_SEP
	
	local h, hs, m, ms, s, ss, xoff, nums;
	
	
	hs = 2;
	h = Number(x, y, r, 2, nil, hs * speed)
	xoff = sep + h:getTopRightEdge()
	
	ms = 2
	m = Number(x + xoff, y, r, 2, nil, ms * speed)
	xoff = xoff + sep + m:getTopRightEdge()
	
	ss = 0.3
	s = Number(x + xoff, y, r, 2, nil, ss * speed)
	
	nums = {h, m, s}
	self.nums = nums
	
	local pt = {hour = -1, min = -1, sec = -1}
	function self:tick(dt)
		local t = os.date("*t")
		if t.hour ~= pt.hour then h:gotoNumber(t.hour) end 
		if t.min ~= pt.min then m:gotoNumber(t.min) end
		if t.sec ~= pt.sec then s:gotoNumber(t.sec) end
		pt = t
		for _, v in ipairs(nums) do v:tick(dt) end
	end
	
	function self:draw()
		for _, v in ipairs(preDrawShader) do v() end
	
		for _, v in ipairs(nums) do v:draw() end
		for _, v in ipairs(sepSprs) do 
			local x = (sep / 2) + h:getTopRightEdge()
			v(x, 0)
			x = x + sep + m:getTopRightEdge()
			v(x, 0)
		end
		
		for _, v in ipairs(postDrawShader) do v() end
	end
	
	function self:attachSep(f)
		table.insert(sepSprs, f)
	end
	
	function self:attachShaderPreDraw(f)
		table.insert(preDrawShader, f)
	end
	
	function self:attachShaderPostDraw(f)
		table.insert(postDrawShader, f)
	end
	
	return self
end