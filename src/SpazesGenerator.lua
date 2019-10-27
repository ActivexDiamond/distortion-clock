local ParticleGenerator = require "ParticleGenerator"

return function()
	local stats = {border = {0, 0, sw, sh}}
	
	local max = 75
	local dat = {r = 5}
	
	local function spawn(p, dat)
		p.x = math.random(0, sw)
		p.y = math.random(0, sh)
	end
	
	local function onDraw(p, dat)
		love.graphics.setColor(0.7, 0.76, 0.7, 0.7)
		local rs = math.random()
		love.graphics.circle('fill', p.x, p.y, dat.r * rs)
	end
	
	local interval = 2
	local elapsed = 0
	local function onMove(p, dt, dat)
		elapsed = elapsed + dt
		if elapsed > interval then
			elapsed = 0
			p.x = math.random(0, sw)
			p.y = math.random(0, sh)
		end
	end
	
	local function onDeath(p, dat)
	
	end
	
	return ParticleGenerator(stats, max, spawn, onDraw, onMove, onDeath, dat)
end



