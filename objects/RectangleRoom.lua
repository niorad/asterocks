RectangleRoom = Object:extend()

function RectangleRoom:new()
end

function RectangleRoom:update(dt)
end

function RectangleRoom:draw()
	love.graphics.rectangle("fill", 20, 20, 100, 100)
end

return RectangleRoom
