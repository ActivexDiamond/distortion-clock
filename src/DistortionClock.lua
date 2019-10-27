local DigitalClock = require "DigitalClock"

---Utility functions
local function intvRnd(val, chance, min, max) 
	local nv = math.random(min, max)
	return math.random() > chance and nv or (val or min)
end

local function concatClks(dclk)
	local t = {}
	for _, num in ipairs(dclk.nums) do
		for _, digit in ipairs(num.digits) do
			for _, clk in ipairs(digit.clks) do
				table.insert(t, clk)
			end
		end
	end
	return t
end

---Shaders
local scale
local sepSpr
do
	local w, b
	function sepSpr(x, y)
		b = intvRnd(b, 0.75, 0.35, 0.43)
		love.graphics.setColor(0.3, 0.3, b, 0.4)
		w = intvRnd(w, 0.75, 1, 15 * scale)
		
		love.graphics.setLineWidth(w)
		love.graphics.line{x, y, x, y + sh}
	end
end

local hDistortion
do
	local a, g, b, lines
	function hDistortion()
		a = intvRnd(a, 0.5, 0.1, 0.25)
		a = intvRnd(a, 0.85, 0.1, 0.5)
		
		g = intvRnd(g, 0.75, 0.3, 0.34)
		b = intvRnd(b, 0.25, 0.33, 0.37)
		
		love.graphics.setColor(0.32, g, b, a)
		
		lines = intvRnd(lines, 0.9, 3, 13)
		local w, y;
		for i = 1, lines do
			w = intvRnd(w, 0.25, 1, 15 * scale)
			y = math.random(w, sh - w)
			
			love.graphics.setLineWidth(w)
			love.graphics.line{0, y, sw, y}
		end
	end
end

local clks = {}
local stickColorShader, stickColorShaderCleanup
do
	local c, r, g, b, a = 0
	function stickColorShader()
		a = intvRnd(a, 0.85, 0.65, 1)
		g = intvRnd(g, 0.85, 0.3, 0.34)
		b = intvRnd(b, 0.85, 0.33, 0.37)
		r = intvRnd(r, 0.25, 0.33, 0.55)
		local col = {r, g, b, a}
	
		a = intvRnd(a, 0.95, 0.75, 1)
		g = intvRnd(g, 0.85, 0.3, 0.34)
		b = intvRnd(b, 0.85, 0.33, 0.40)
		r = intvRnd(r, 0.25, 0.33, 0.55)
		local colOut = {r, g, b, a}
		colOut = {r, g, b, a}
	 
	 	if math.random() > 0.995 or c > 0 then
	 		c = c > 0 and c - 1 or 50
	 		print('c', c) 
			for _, v in ipairs(clks) do
				v.col = col
				v.colOutline = colOut
			end
		end
		
		if c <= 0 then
			for _, v in ipairs(clks) do
				v.col = v.DEFAULT_COL
				v.colOutline = v.DEFAULT_COL_OUTLINE
			end
		end
	end
end

return function(s)
	scale = s or 1 --External option.
	
	---Configs
	local radius = 50 * scale
	local sep = 25 * scale
	local clocks = 3
	local speed = 1
	
	---dclk construction.
	local x, y, r, sep, sm = 0, 0, radius, sep, 1
	local dclk = DigitalClock(x, y, r, sep, sm)
	
	---dclk relateed variables setup.
	clks = concatClks(dclk)
	dclk:attachSep(sepSpr)
	dclk:attachShaderPreDraw(stickColorShader)
	dclk:attachShaderPostDraw(hDistortion)
	
	---Attaching utility methods to the underlying DigitalClock.
	function dclk:getW()
		local d = radius * 2
		local numw = d * 2
		local segw = numw * 2
		local segs = 3
		local segsw = segw * segs
		local sep = sep * (segs - 1)
		local extra = 5
		return segsw + sep + extra
	end
	
	function dclk:getH()
		local d = radius * 2
		return d * 3
	end

	return dclk
end






