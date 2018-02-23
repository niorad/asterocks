CircleRoom = Object:extend()

function CircleRoom:new()
end

function CircleRoom:update(dt)
end

function CircleRoom:draw()
	love.graphics.circle("fill", 100, 100, 100)
end

return CircleRoom
