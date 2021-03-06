function UUID()
	local fn = function(x)
		local r = love.math.random(16) - 1
		r = (x == "x") and (r + 1) or (r % 4) + 9
		return ("0123456789abcdef"):sub(r, r)
	end
	return (("XXXXXXXXX-XXXX-4xxx-yxxx-xxxxxxxxxxx"):gsub("[xy]", fn))
end

function dist(x1, y1, x2, y2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

function random(min, max)
	local min, max = min or 0, max or 1
	return (min > max and (love.math.random() * (min - max) + max)) or (love.math.random() * (max - min) + min)
end

function pushRotate(x, y, r)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(r or 0)
	love.graphics.translate(-x, -y)
end

function pushRotateScale(x, y, r, sx, sy)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(r or 0)
	love.graphics.scale(sx or 1, sy or sx or 1)
	love.graphics.translate(-x, -y)
end

function slow(amount, duration)
	slow_amount = amount
	timer:tween("slow", duration, _G, {slow_amount = 1}, "in-out-cubic")
end

function flash(seconds)
	flash_active = true
	timer:after(
		seconds,
		function()
			flash_active = false
		end
	)
end
