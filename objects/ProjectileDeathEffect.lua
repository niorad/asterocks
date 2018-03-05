ProjectileDeathEffect = GameObject:extend()

function ProjectileDeathEffect:new(area, x, y, opts)
	ProjectileDeathEffect.super.new(self, area, x, y, opts)
	current_color = default_color
	self.timer:after(
		0.25,
		function()
			current_color = self.color
			self.dead = true
		end
	)
end

function ProjectileDeathEffect:draw()
	love.graphics.setColor(current_color)
	love.graphics.rectangle("fill", self.x - self.w / 2, self.y - self.w / 2, self.w, self.w)
end
