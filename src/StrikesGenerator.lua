local ParticleGenerator = require "ParticleGenerator"

local function intvRnd(val, chance, min, max) 
	local nv = math.random(min, max)
	return math.random() > chance and nv or (val or min)
end

local function cartFromPolar(r, a)
	return r * math.cos(a), r * math.sin(a)
end

return function()
	local stats = {border = {0, 0, sw, sh}}
	
	local max = 25
	local dat = {}
	
	local function spawn(p, dat)
		p.x = math.random(0, sw)
		p.y = math.random(0, sh)
		p.a = math.random(0, 360)
	end
	
	local function onDraw(p, dat)
		p.w = intvRnd(p.w, 0.25, 0.1, 1)
		p.l = intvRnd(p.l, 0.95, 5, 25)
--		local px, py = p.x - (p.l / 2), p.y - (p.l / 2)
		local x, y = cartFromPolar(p.l, p.a)
		x, y = x + p.x, y + p.y
		
		love.graphics.setColor(0.7, 0.7, 0.0, 0.3)
		love.graphics.setLineWidth(p.w)
		love.graphics.line{p.x, p.y, x, y}
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



