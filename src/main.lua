local DistortionClock = require "DistortionClock"

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
			]]
	},
}
 
scale = 0.7;

local dclk;
function love.load()
	dclk = DistortionClock(scale)

	local flags = {borderless = true, centered = false}
	love.window.setMode(dclk:getW(), dclk:getH(), flags) 
	love.window.setPosition(0, 0, 2)
	sw, sh = love.window.getMode()
end	

function love.update(dt)
	dclk:tick(dt)
end


function love.draw()
	dclk:draw()
end

