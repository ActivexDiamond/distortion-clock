local ParticleGenerator = require "ParticleGenerator"

local sm = 2
local function xg()
--	return math.random(0.5, 3)
	return math.random(0.5 / sm, 3 / sm)
end

local function yg()
--	return math.random(3, 8)
	return math.random(3 / sm, 8 / sm)
end

local function maxDist()
	return math.random(sh * 1.3, sh * 2)
end

return function()
	local stats = {xg = xg, yg = yg,
		border = {0, 0, sw, sh}	
	}
	local max = 1e3
	local dat = {r = 5}
	
	local function spawn(p, dat)
		p.x = math.random(-50, sw)
		p.y = math.random(0, -max)
	end
	
	local function onDraw(p, dat)
		love.graphics.setColor(0.7, 0.7, 0.7, 0.7)
		local rs = math.random()
		love.graphics.circle('fill', p.x, p.y, dat.r * rs)
	end
	
	local function onMove(p, dat)
		local m = 3
		p.x = p.x + math.random(-m, m)
		p.y = p.y + math.random(-m, m)
	end
	
	local function onDeath(p, dat)
	
	end
	
	
	return ParticleGenerator(stats, max, spawn, onDraw, onMove, onDeath, dat)
end