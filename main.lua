Object = require "libraries/classic/classic"
Input = require "libraries/boipushy/input"
Timer = require "libraries/enhanced_timer/EnhancedTimer"

function love.load()
	local object_files = {}
	recursiveEnumerate("objects", object_files)
	requireFiles(object_files)
	timer = Timer()
	rect_1 = {x = 400, y = 300, w = 50, h = 200}
	rect_2 = {x = 400, y = 300, w = 200, h = 50}
	timer:tween(
		1,
		rect_1,
		{w = 0},
		"in-out-cubic",
		function()
			timer:tween(
				1,
				rect_2,
				{h = 0},
				"in-out-cubic",
				function()
					timer:tween(2, rect_1, {w = 50}, "in-out-cubic")
					timer:tween(2, rect_2, {h = 50}, "in-out-cubic")
				end
			)
		end
	)
end

function love.update(dt)
	timer:update(dt)
end

function love.draw()
	love.graphics.rectangle("fill", rect_1.x - rect_1.w / 2, rect_1.y - rect_1.h / 2, rect_1.w, rect_1.h)
	love.graphics.rectangle("fill", rect_2.x - rect_2.w / 2, rect_2.y - rect_2.h / 2, rect_2.w, rect_2.h)
end

-- brumma
function requireFiles(files)
	for _, file in ipairs(files) do
		local file = file:sub(1, -5)
		local last_forward_slash_index = file:find("/[^/]*$")
		local class_name = file:sub(last_forward_slash_index + 1, #file)
		_G[class_name] = require(file)
	end
end

function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local file = folder .. "/" .. item
		if love.filesystem.isFile(file) then
			table.insert(file_list, file)
		elseif love.filesystem.isDirectory(file) then
			recursiveEnumerate(file, file_list)
		end
	end
end

function love.run()
	if love.math then
		love.math.setRandomSeed(os.time())
	end

	if love.load then
		love.load(arg)
	end
	if love.timer then
		love.timer.step()
	end

	local dt = 0
	local fixed_dt = 1 / 60
	local accumulator = 0

	while true do
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a, b, c, d, e, f)
			end
		end

		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		accumulator = accumulator + dt
		while accumulator >= fixed_dt do
			if love.update then
				love.update(fixed_dt)
			end
			accumulator = accumulator - fixed_dt
		end

		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then
				love.draw()
			end
			love.graphics.present()
		end

		if love.timer then
			love.timer.sleep(0.001)
		end
	end
end
