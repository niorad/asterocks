PolygonRoom = Object:extend()

function PolygonRoom:new()
end

function PolygonRoom:update(dt)
end

function PolygonRoom:draw()
	love.graphics.polygon("fill", 10, 10, 50, 50, 10, 50)
end

return PolygonRoom
