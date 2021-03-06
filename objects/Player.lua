require "objects/ships/ships"
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
	self.base_max_v = 100
	self.max_v = self.base_max_v
	self.ship = "Bracket"
	self.polygons = getShip(self.ship, self.w)
	self.max_boost = 100
	self.boost = self.max_boost
	self.can_boost = true
	self.boost_timer = 0
	self.boost_cooldown = 2
	self.max_hp = 100
	self.hp = self.max_hp
	self.max_ammo = 100
	self.ammo = self.max_ammo

	self.timer:every(
		0.24,
		function(f)
			self:shoot()
		end
	)

	self.timer:every(
		5,
		function()
			self:tick()
		end
	)

	self.trail_color = skill_point_color
	self.timer:every(
		0.01,
		function()
			if self.ship == "Fighter" then
				self.area:addGameObject(
					"TrailParticle",
					self.x - 0.9 * self.w * math.cos(self.r) + 0.2 * self.w * math.cos(self.r - math.pi / 2),
					self.y - 0.9 * self.w * math.sin(self.r) + 0.2 * self.w * math.sin(self.r - math.pi / 2),
					{parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}
				)
				self.area:addGameObject(
					"TrailParticle",
					self.x - 0.9 * self.w * math.cos(self.r) + 0.2 * self.w * math.cos(self.r + math.pi / 2),
					self.y - 0.9 * self.w * math.sin(self.r) + 0.2 * self.w * math.sin(self.r + math.pi / 2),
					{parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}
				)
			end
			if self.ship == "Coelacanth" then
				self.area:addGameObject(
					"TrailParticle",
					self.x - 1.8 * self.w * math.cos(self.r),
					self.y - 1.8 * self.w * math.sin(self.r),
					{parent = self, r = random(.5, 5), d = random(0.35, 0.45), color = self.trail_color}
				)
			end
			if self.ship == "Nemo" then
				self.area:addGameObject(
					"TrailParticle",
					self.x - 1 * self.w * math.cos(self.r),
					self.y - 1 * self.w * math.sin(self.r),
					{parent = self, r = random(.5, 1), d = random(0.35, 0.45), color = self.trail_color}
				)
			end
			if self.ship == "Bracket" then
				self.area:addGameObject(
					"TrailParticle",
					self.x - 1.7 * self.w * math.cos(self.r),
					self.y - 1.7 * self.w * math.sin(self.r),
					{parent = self, r = random(5, 6), d = random(0.05, 0.15), color = self.trail_color}
				)
			end
		end
	)

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Player")

	input:bind(
		"p",
		function()
			self:die()
		end
	)
end

function Player:update(dt)
	Player.super.update(self, dt)

	self.boost = math.min(self.boost + 10 * dt, self.max_boost)

	self.boost_timer = self.boost_timer + dt
	if self.boost_timer > self.boost_cooldown then
		self.can_boost = true
	end
	self.max_v = self.base_max_v
	self.boosting = false

	if input:down("left") then
		self.r = self.r - self.rv * dt
	end
	if input:down("right") then
		self.r = self.r + self.rv * dt
	end
	if input:down("up") and self.boost > 1 and self.can_boost then
		self.boosting = true
		self.max_v = 1.5 * self.base_max_v
		self.boost = self.boost - 50 * dt
		if self.boost <= 1 then
			self.boosting = false
			self.can_boost = false
			self.boost_timer = 0
		end
	end
	if input:down("down") and self.boost > 1 and self.can_boost then
		self.boosting = true
		self.max_v = 0.5 * self.base_max_v
		self.boost = self.boost - 50 * dt
		if self.boost <= 1 then
			self.boosting = false
			self.can_boost = false
			self.boost_timer = 0
		end
	end
	self.trail_color = skill_point_color
	if self.boosting then
		self.trail_color = boost_color
	end

	self.v = self.v + self.a * dt
	if self.v >= self.max_v then
		self.v = self.max_v
	end

	self.v = math.min(self.v + self.a * dt, self.max_v)
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

	if self.collider:enter("Collectable") then
		local collision_data = self.collider:getEnterCollisionData("Collectable")
		local object = collision_data.collider:getObject()
		if object:is(Ammo) then
			object:die()
		end
	end
end

function Player:draw()
	pushRotate(self.x, self.y, self.r)
	love.graphics.setColor(default_color)
	for unused, polygon in ipairs(self.polygons) do
		local points =
			_.map(
			polygon,
			function(k, v)
				if k % 2 == 1 then
					return self.x + v + random(-player_wobbly, player_wobbly)
				else
					return self.y + v + random(-player_wobbly, player_wobbly)
				end
			end
		)
		love.graphics.polygon("line", points)
	end
	love.graphics.pop()
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

function Player:tick()
	self.area:addGameObject("TickEffect", self.x, self.y, {parent = self})
end

function Player:die()
	self.dead = true
	for i = 1, love.math.random(5, 10) do
		self.area:addGameObject("ExplodeParticle", self.x, self.y)
	end
	flash(0.01)
	slow(0.15, 1)
	camera:shake(6, 60, 0.4)
end
