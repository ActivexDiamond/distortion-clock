local function callAll(t, ...)
	for _, v in ipairs(t) do
		v(...)
	end
end

--- @function [parent=#Particle] init Construct a new particle.
-- @param #number x The starting x-coord of the particle.
-- @param #number y The starting y-coord of the particle.
-- @param #number xg The gravity affecting the particle on the x-axis.
-- @param #number yg The gravity affecting the particle on the y-axis.
-- @param #number timeout The particle's max lifespan. Can be zero.
-- @param #number dist The max distance the particle is allowed to travel from it's starting x/y position before despawning. Can be zero. 
-- @param #number border A rectangle which the particle will despawn if it leaves. Can be nil.
-- @param #function move A method called every tick, mainly intended for movement; but can be used for other things as well.
-- @param #function onDeath A callback called when the particle despawns.
-- @param #function draw The particle's draw method.
-- @param #any ... Any extra arguments are simply passed to 'draw'.
return function(spawn, xg, yg, timeout, maxDist, border, dat)
	local self = {}
	self.x, self.y, self.xg, self.yg = 0, 0, xg, yg
	self.timeout, self.maxDist, self.border = timeout, maxDist, border
	
	local ox, oy = x, y;
	self.age, self.dead  = 0, false
	self.dist = 0
	self.onDeath, self.onDraw, self.onMove = {}, {}, {}
	
	spawn(self, dat)
	function self:tick(dt)
		if self.dead then return end
		self.age = self.age	+ dt
		if self.timeout > 0 and self.age > self.timeout then self:despawn() end

		self.x, self.y = self.x + self.xg, self.y + self.yg
		self.dist = self.dist + (self.xg^2 + self.yg^2)^0.5
		if self.maxDist > 0 and self.dist > self.maxDist then self:despawn() end 
		if self.border and not self:intersects(self.border) then self:despawn() end

		callAll(self.onMove, self, dt, dat)
	end
	
	function self:draw()
		if self.dead then return end
		callAll(self.onDraw, self, dat)
	end

	function self:attachOnDraw(f)
		table.insert(self.onDraw, f)	
	end
	
	function self:attachOnMove(f)
		table.insert(self.onMove, f)	
	end
		
	function self:attachOnDeath(f)
		table.insert(self.onDeath, f)	
	end
	
	function self:despawn()
		self.dead = true
		callAll(self.onDeath, self, dat)
	end
	
	function self:intersects(r)
		local rx, ry, rw, rh = r[1], r[2], r[3], r[4]
		local x, y = self.x, self.y
		return x > rx and
			x < rx + rw and
			y > ry and
			y < ry + rh
	end
	
	return self
end