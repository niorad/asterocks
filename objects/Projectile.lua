Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
	Projectile.super.new(self, area, x, y, opts)
	self.s = opts.s or 2.5
	self.v = opts.v or 200
	self.r = opts.r

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Projectile:update(dt)
	Projectile.super.update(self, dt)
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Projectile:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle("line", self.x, self.y, self.s)
end
