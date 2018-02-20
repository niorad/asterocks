Circle = Object:extend()

function Circle:new(x, y, radius)
	self.x = x or 0
	self.y = y or 0
	self.radius = radius or 0
	self.creation_time = love.timer.getTime()
end

function Circle:update(dt)
end

function Circle:draw()
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

HyperCircle = Circle:extend()

function HyperCircle:new(x, y, radius, lineWidth, outerRadius)
	HyperCircle.super.new(self, x, y, radius)
	self.lineWidth = lineWidth or 0
	self.outerRadius = outerRadius or 0
end

function HyperCircle:draw()
	HyperCircle.super.draw(self)
	love.graphics.setLineWidth(self.lineWidth)
	love.graphics.circle("line", self.x, self.y, self.outerRadius)
end
