Object = require "libraries/classic/classic"
Input = require "libraries/boipushy/input"
Timer = require "libraries/enhanced_timer/EnhancedTimer"
Camera = require "libraries/hump/camera"
Vector = require "libraries/hump/vector"
Physics = require "libraries/windfield"
Draft = require "libraries/draft/draft"
draft = Draft()
_ = require "libraries/moses/moses"
require "GameObject"
require "utils"
require "globals"

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")
	local object_files = {}
	recursiveEnumerate("objects", object_files)
	requireFiles(object_files)
	local room_files = {}
	recursiveEnumerate("rooms", room_files)
	requireFiles(room_files)

	timer = Timer()
	input = Input()
	camera = Camera()

	input:bind(
		"s",
		function()
			camera:shake(4, 60, 1)
		end
	)

	input:bind(
		"f1",
		function()
			print("Before collection: " .. collectgarbage("count") / 1024)
			collectgarbage()
			print("After collection: " .. collectgarbage("count") / 1024)
			print("Object count: ")
			local counts = type_count()
			for k, v in pairs(counts) do
				print(k, v)
			end
			print("----------------------------------------")
		end
	)
	input:bind(
		"f2",
		function()
			gotoRoom("Stage")
		end
	)

	input:bind(
		"f3",
		function()
			if (current_room) then
				current_room:destroy()
				current_room = nil
			end
		end
	)

	input:bind("left", "left")
	input:bind("right", "right")
	input:bind("up", "up")
	input:bind("down", "down")

	rooms = {}
	current_room = nil
	slow_amount = 1

	gotoRoom("Stage")
	resize(scale_amount)
end

function love.update(dt)
	timer:update(dt * slow_amount)
	camera:update(dt * slow_amount)
	if current_room then
		current_room:update(dt * slow_amount)
	end
end

function love.draw(dt)
	if current_room then
		current_room:draw(dt)
	end
	if flash_active then
		love.graphics.setColor(default_color)
		love.graphics.rectangle("fill", 0, 0, sx * gw, sy * gw)
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.print(dt, 10, 10)
end

function addRoom(room_type, room_name, ...)
	local room = _G[room_type](room_name, ...)
	rooms[room_name] = room
	return room
end

function gotoRoom(room_type, ...)
	if current_room and current_room.destroy then
		current_room:destroy()
	end
	current_room = _G[room_type](...)
end

function resize(s)
	love.window.setMode(s * gw, s * gh)
	sx, sy = s, s
end

-- brumma
function requireFiles(files)
	for _, file in ipairs(files) do
		local file = file:sub(1, -5)
		require(file)
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
				love.draw(dt)
			end
			love.graphics.present()
		end

		if love.timer then
			love.timer.sleep(0.001)
		end
	end
end
function count_all(f)
	local seen = {}
	local count_table
	count_table = function(t)
		if seen[t] then
			return
		end
		f(t)
		seen[t] = true
		for k, v in pairs(t) do
			if type(v) == "table" then
				count_table(v)
			elseif type(v) == "userdata" then
				f(v)
			end
		end
	end
	count_table(_G)
end

function type_count()
	local counts = {}
	local enumerate = function(o)
		local t = type_name(o)
		counts[t] = (counts[t] or 0) + 1
	end
	count_all(enumerate)
	return counts
end

global_type_table = nil
function type_name(o)
	if global_type_table == nil then
		global_type_table = {}
		for k, v in pairs(_G) do
			global_type_table[v] = k
		end
		global_type_table[0] = "table"
	end
	return global_type_table[getmetatable(o) or 0] or "Unknown"
end
