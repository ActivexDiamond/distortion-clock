local MAX_H, MIN_H = 12, 0
local DEFAULT_R = 5
local DEFAULT_COL = {1, 1, 1, 1} 
local DEFAULT_COL_OUTLINE = {1, 1, 1, 0.1}

local function map(x, min, max, nmin, nmax)
 return (x - min) * (nmax - nmin) / (max - min) + nmin
end

local function cartFromPolar(r, a)
	return r * math.cos(a), r * math.sin(a)
end
local function parseTime(t)
	t = t or 0.0
	if not (MAX_H >= t and t >= MIN_H) then t = 0.0 end
	local h, m = math.modf(t)
	m = math.floor(m * 60) 
	return t, h, m
end


return function(ox, oy, x, y, r, t) 
	local self = {}
	ox, oy = ox or 0, oy or 0
	x, y = x or 0, y or 0
	local t, h, m = parseTime(t)
	local r = r or DEFAULT_R
	self.col = DEFAULT_COL or {1, 1, 1, 1}
	self.colOutline = DEFAULT_COL_OUTLINE or {1, 1, 1, 0.1}
	local travelling = false
	local pt, ds, nt = 0, 0, -1
	
	self.MAX_H, self.MIN_H = MAX_H, MIN_H
	self.DEFAULT_R = DEFAULT_R
	self.DEFAULT_COL = DEFAULT_COL
	self.DEFAULT_COL_OUTLINE = DEFAULT_COL_OUTLINE
	
	function self:tick(dt)
		if not travelling then return end
		pt = t
		t, h, m = parseTime(t + ds * dt)
		if t < pt then nt = nt - MAX_H end
		if t >= nt then 
			t = nt
			travelling = false
			t, h, m = parseTime(t)
		end
	end
		
	function self:gotoTime(_nt, _p)
		if _nt == t then return end
		travelling = true
		if _nt < t then nt = _nt + MAX_H
		else nt = _nt end
		local p = _p and _p ~= 0 and _p or 1
		ds = (nt - t) / p
	end
	
	function self:draw()
		love.graphics.setColor(self.colOutline)
		local dx = ox + x * r * 2 + r
		local dy = oy + y * r * 2 + r
		love.graphics.push("all")
			love.graphics.translate(dx, dy)
			love.graphics.circle('line', 0, 0, r)
			
			love.graphics.setColor(self.col)			
			love.graphics.circle('fill', 0, 0, r * 0.1)
			
			local lx, ly, a;
				a = map(h, MIN_H, MAX_H, 0, math.pi * 2);
				lx, ly = cartFromPolar(r, a - math.pi / 2)
				love.graphics.line{0, 0, lx, ly}
				a = map(m, 0, 60, 0, math.pi * 2);
				lx, ly = cartFromPolar(r, a - math.pi / 2)
				love.graphics.line{0, 0, lx, ly}
		love.graphics.pop()
	end
	
	function self:setTime(_t) 
		t, h, m = parseTime(_t)
	end
	function self:getTime() return t end
	function self:getTimeStr()
		return string.format("%dh%dm", h, m)
	end
	
	function self:setCoords(_x, _y) x, y = _x, _y end
	function self:getCoords() return x, y end
		function self:getCoordsStr()
		return string.format("(%d, %d)", x, y)
	end
	
	function self:__tostring()
		return string.format("%s | %s", 
			self:getCoordsStr(), self:getTimeStr())
	end
	
	setmetatable(self, self)
	return self;
end