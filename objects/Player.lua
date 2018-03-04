Player = GameObject:extend()

function Player:new(area, x, y, opts)
	Player.super.new(self, area, x, y, opts)

	self.x, self.y = x, y
	self.w, self.h = 12, 12

	self.r = 0
	self.rv = 1.66 * math.pi
	self.v = 0
	self.max_v = 50
	self.a = 100

	self.timer:every(
		0.24,
		function(f)
			self:shoot()
		end
	)

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setObject(self)

	input:bind(
		"p",
		function()
			self:die()
		end
	)
end

function Player:update(dt)
	Player.super.update(self, dt)

	if input:down("left") then
		self.r = self.r - self.rv * dt
	end
	if input:down("right") then
		self.r = self.r + self.rv * dt
	end

	self.v = self.v + self.a * dt
	if self.v >= self.max_v then
		self.v = self.max_v
	end

	self.v = math.min(self.v + self.a * dt, self.max_v)
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Player:draw()
	love.graphics.circle("line", self.x, self.y, self.w)
end

function Player:destroy()
	Player.super.destroy(self)
end

function Player:shoot()
	local d = self.w
	self.area:addGameObject(
		"Projectile",
		self.x + 1.5 * d * math.cos(self.r),
		self.y + 1.5 * d * math.sin(self.r),
		{
			r = self.r,
			v = 200,
			s = 3
		}
	)

	self.area:addGameObject(
		"ShootEffect",
		self.x + d * math.cos(self.r),
		self.y + d * math.sin(self.r),
		{
			player = self,
			d = d
		}
	)
end

function Player:die()
	self.dead = true
	for i = 1, love.math.random(5, 10) do
		self.area:addGameObject("ExplodeParticle", self.x, self.y)
	end
end
