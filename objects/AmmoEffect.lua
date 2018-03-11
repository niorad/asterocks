AmmoEffect = GameObject:extend()

function AmmoEffect:new(area, x, y, opts)
	AmmoEffect.super.new(self, area, x, y, opts)
	current_color = default_color
	self.timer:after(
		0.25,
		function()
			current_color = self.color
			self.dead = true
		end
	)
end

function AmmoEffect:draw()
	love.graphics.setColor(current_color)
	draft:rhombus(self.x, self.y, self.w, self.h, "fill")
end
