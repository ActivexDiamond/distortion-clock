local Clock = require "Clock"
local Digit = require "Digit"
local Number = require "Number"
local DigitalClock = require "DigitalClock"

DISTORTION_CLOCK = {
	TITLE = "Distortion Clock",
	DESC = "A digital clock built out of analog clocks, with some shader-effects on top.", 
	VER = "1.0.0",
	CHANGELOG = "First release."
}
 
SCALE = 0.7;

RADIUS = 50 * SCALE
SEP = 25 * SCALE

CLOCKS = 3
COL_CLK = {1, 1, 1} 
COL_CLK_OUTLINE = {1, 1, 1, 0.1}
SPEED = 1

local function intvRnd(val, chance, min, max) 
	local nv = math.random(min, max)
	return math.random() > chance and nv or (val or min)
end

local sepSpr
do
	local w, b
	function sepSpr(x, y)
		b = intvRnd(b, 0.75, 0.35, 0.43)
		love.graphics.setColor(0.3, 0.3, b, 0.4)
		w = intvRnd(w, 0.75, 1, 15 * SCALE)
		
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
			w = intvRnd(w, 0.25, 1, 15 * SCALE)
			y = math.random(w, sh - w)
			
			love.graphics.setLineWidth(w)
			love.graphics.line{0, y, sw, y}
		end
	end
end


local clks = {}
local stickColorShader, stickColorShaderCleanup
do
	local c = 0
	local r, g, b, a
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
	 		c = c > 0 and c - 1 or 25
	 		print('c', c) 
			for _, v in ipairs(clks) do
				v.col = col
				v.colOutline = colOut
			end
		end
	end

	function stickColorShaderCleanup()
		if c > 0 then return end
		for _, v in ipairs(clks) do
			v.col = v.DEFAULT_COL
			v.colOutline = v.DEFAULT_COL_OUTLINE
		end
	end
end

local dclk;
function love.load()
	local x, y, r, sep, sm = 0, 0, RADIUS, SEP, 1
	dclk = DigitalClock(x, y, r, sep, sm)
	dclk:attachSep(sepSpr)
	dclk:attachShaderPreDraw(stickColorShader)
	dclk:attachShaderPreDraw(stickColorShaderCleanup)
--	dclk:attachShaderPostDraw(stickColorShaderCleanup)
	
	for _, num in ipairs(dclk.nums) do
		for _, digit in ipairs(num.digits) do
			for _, clk in ipairs(digit.clks) do
				table.insert(clks, clk)
			end
		end
	end

	do
		local d = RADIUS * 2
		local clkh = d * 3
		local numw = d * 2
		local segw = numw * 2
		local segs = 3
		local segsw = segw * segs
		local sep = SEP * (segs - 1)
		local extra = 5
		local flags = {borderless = true, centered = false}
		love.window.setMode(segsw + sep + extra, clkh, flags) 
		love.window.setPosition(0, 0, 2)
		sw, sh = love.window.getMode()
	end
	
end	

function love.update(dt)
	dclk:tick(dt)
end


function love.draw()
	dclk:draw()
	hDistortion()
end

local d = 0
local pd = 0

function love.keypressed(key, code, isrepeat)
	pd = d
	d = tonumber(key)
	if type(d) == 'number' then num:gotoNumber(d + pd * 10) end
end

--[[

t = 3.0
nt = 6.0
p = 6

dt = 3.0
ds = dt/p = 0.5

t = 3.0
nt = 1.0

dt = 10


--]]


