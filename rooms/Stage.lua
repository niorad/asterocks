Stage = Object:extend()

function Stage:new()
	self.area = Area(self)
	self.area:addPhysicsWorld()
	self.timer = Timer()
	self.main_canvas = love.graphics.newCanvas(gw, gh)
	self.player = self.area:addGameObject("Player", gw / 2, gh / 2)
	input:bind(
		"d",
		function()
			self.player.dead = true
			self.player = nil
		end
	)
end

function Stage:update(dt)
	camera.smoother = Camera.smooth.damped(5)
	camera:lockPosition(dt, gw / 2, gh / 2)
	if (self.area) then
		self.area:update(dt)
	end
	self.timer:update(dt)
end

function Stage:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach(0, 0, gw, gh)
	if (self.area) then
		self.area:draw()
	end
	camera:detach()
	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
	love.graphics.setBlendMode("alpha")
end

function Stage:destroy()
	self.area:destroy()
	self.area = nil
end
