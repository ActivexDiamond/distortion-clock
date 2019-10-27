local DistortionClock = require "DistortionClock"
local SpazesGenerator = require "SpazesGenerator"
local StrikesGenerator = require "StrikesGenerator"

DISTORTION_CLOCK = {
	TITLE = "Distortion Clock",
	DESC = "A digital clock built out of analog clocks, with some shader-effects on top.", 
	VER = "1.0.0",
	CHANGELOG = {
		["1.0.0"] = [[
			- First release.
			]],
		["1.1.0"] = [[
			- Increased duration of stickColorShader after activation from 25 to 50 frames.
			- Removed deprecated debug-code from keypress events (which was causing crashes).
			- Cleaned up the imports in main.lua.
			- Refactored main.lua out into DistortionClock.lua, cleaning it up greatly.
			]],
		["1.2.0"] = [[
			- Removed debug 'print' from 'stickColorShader'.
			- Added the ability to scale the clock with the scroll wheel.
			- Added a touch of empty space around the bottom and right edges of the clock.
			- Randomized the RNG's seed.
			]]
	},
}
scale = 0.7;

local dclk;
local stgen, spgen;
function love.load()
	math.randomseed(os.time())
	
	dclk = DistortionClock(scale)
	local flags = {borderless = true, centered = false}
	love.window.setMode(dclk:getW(), dclk:getH(), flags) 
	love.window.setPosition(0, 0, 2)
	love.window.setPosition(50, 50, 2)
	sw, sh = love.window.getMode()
	
	stgen = StrikesGenerator()
	spgen = SpazesGenerator()
end	

function love.update(dt)
	dclk:tick(dt)
	stgen:tick(dt)
	spgen:tick(dt)
end


function love.draw()
	dclk:draw()
	stgen:draw()
	spgen:draw()	
end

function love.wheelmoved(x, y)
	scale = scale + (y * 0.05)
	love.load()
end

	
	
	
	
	
	
	
	
	
	
	
	
	