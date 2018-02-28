Area = Object:extend()

function Area:new(room)
	self.room = room
	self.game_objects = {}
end

function Area:update(dt)
	if self.world then
		self.world:update(dt)
	end

	for i = #self.game_objects, 1, -1 do
		local game_object = self.game_objects[i]
		game_object:update(dt)
		if game_object.dead then
			game_object:destroy()
			table.remove(self.game_objects, i)
		end
	end
end

function Area:draw()
	if self.world then
	-- self.world:draw()
	end
	for _, game_object in ipairs(self.game_objects) do
		game_object:draw()
	end
end

function Area:addGameObject(game_object_type, x, y, opts)
	local opts = opts or {}
	local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
	game_object.className = game_object_type
	table.insert(self.game_objects, game_object)
	return game_object
end

function Area:addPhysicsWorld()
	self.world = Physics.newWorld(0, 0, true)
end

function Area:destroy()
	for i = #self.game_objects, 1, -1 do
		local game_object = self.game_objects[i]
		game_object:destroy()
		table.remove(self.game_objects, i)
	end
	self.game_objects = {}
	if self.world then
		self.world:destroy()
		self.world = nil
	end
end

function Area:queryCircleArea(x, y, r, types)
	objects_in_radius = {}
	if (#self.game_objects == 0) then
		return false
	end
	for _, v in pairs(self.game_objects) do
		if (dist(v.x, v.y, x, y) <= r) then
			for _, ty in pairs(types) do
				if (v:is(ty)) then
					table.insert(objects_in_radius, v)
				end
			end
		end
	end
	return objects_in_radius
end

function Area:getClosestGameObject(x, y, r, types)
	sorted_objects = {}
	if (#self.game_objects == 0) then
		return false
	end
	sorted_objects =
		_.sort(
		self.game_objects,
		function(a, b)
			return dist(a.x, a.y, x, y) < dist(b.x, b.y, x, y)
		end
	)
	return sorted_objects[1]
end

function Area:getGameObjects(fn)
	return _.filter(self.game_objects, fn)
end

return Area
