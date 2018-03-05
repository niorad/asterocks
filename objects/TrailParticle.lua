TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
	TrailParticle.super.new(self, area, x, y, opts)
	self.r = opts.r or random(4, 6)
	self.timer:tween(
		opts.d or random(0.3, 0.5),
		self,
		{r = 0},
		"linear",
		function()
			self.dead = true
		end
	)
end

function TrailParticle:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.x, self.y, self.r)
	love.graphics.setColor(default_color)
end
