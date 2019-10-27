local Particle = require "Particle"

local function attachAll(inst, f, t)
	t = type(t) == 'table' and t or {t}
	for _, v in ipairs(t) do f(inst, v) end
end

local function decode(f)
	if type(f) == 'function' then return f()
	else return f end
end

return function(stats, maxParticles, spawn, onDraw, onMove, onDeath, dat)
	local self = {}
	self.xg = decode(stats.xg) or 0
	self.yg = decode(stats.yg) or 0
	self.timeout = decode(stats.timeout) or 0
	self.maxDist = decode(stats.maxDist) or 0
	self.border = decode(stats.border) or nil
	
	self.particles = {}
	self.maxParticles = maxParticles or 20;
	
	function self.gc(p)
		for k, v in ipairs(self.particles) do
			if v == p then table.remove(self.particles, k); return end
		end
	end
	
	function self:spawn()
		local p = Particle(spawn, self.xg, self.yg, self.timeout,
			self.maxDist, self.border, dat)
		p:attachOnDeath(self.gc)
		attachAll(p, p.attachOnDraw, onDraw)
		attachAll(p, p.attachOnMove, onMove)
		attachAll(p, p.attachOnDeath, onDeath)
		table.insert(self.particles, p)
	end

	function self:tick(dt)
		while #self.particles < self.maxParticles do self:spawn() end
		for _, v in ipairs(self.particles) do v:tick(dt) end
	end
	
	function self:draw()
		for _, v in ipairs(self.particles) do v:draw() end
	end
	
	return self
end