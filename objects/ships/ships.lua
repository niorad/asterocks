function getShip(name, size)
	local polys = {}
	local size = size or 20

	if name == "Bracket" then
		polys[1] = {
			size / 2,
			0,
			0,
			size / 2,
			size,
			size,
			-size / 2,
			size,
			-size * 0.75,
			size / 4,
			-size * 1.25,
			size / 4,
			-size * 1.25,
			-size / 4,
			-size * 0.75,
			-size / 4,
			-size / 2,
			-size,
			size,
			-size,
			0,
			-size / 2
		}
	end

	if name == "Nemo" then
		polys[1] = {
			size * 0.75,
			0,
			size,
			size / 4,
			0,
			size,
			-size,
			size / 2,
			-size / 2,
			0,
			-size,
			-size / 2,
			0,
			-size,
			size,
			-size / 4
		}
		polys[2] = {
			-size * 0.75,
			0,
			-size * 1.25,
			size / 2,
			-size * 1.25,
			-size / 2
		}
	end
	if name == "Coelacanth" then
		polys[1] = {
			size / 2,
			size / 2,
			-size,
			size,
			-size,
			-size,
			size / 2,
			-size / 2
		}

		polys[2] = {
			size / 4,
			size / 4,
			-size / 4,
			size / 4,
			-size / 4,
			-size / 4,
			size / 4,
			-size / 4
		}

		polys[3] = {
			-size,
			size / 4,
			-size * 1.5,
			0,
			-size,
			-size / 4
		}
	end
	if name == "Fighter" then
		polys[1] = {
			size,
			0, -- 1
			size / 2,
			-size / 2, -- 2
			-size / 2,
			-size / 2, -- 3
			-size,
			0, -- 4
			-size / 2,
			size / 2, -- 5
			size / 2,
			size / 2 -- 6
		}

		polys[2] = {
			size / 2,
			-size / 2, -- 7
			0,
			-size, -- 8
			-size - size / 2,
			-size, -- 9
			-3 * size / 4,
			-size / 4, -- 10
			-size / 2,
			-size / 2 -- 11
		}

		polys[3] = {
			size / 2,
			size / 2, -- 12
			-size / 2,
			size / 2, -- 13
			-3 * size / 4,
			size / 4, -- 14
			-size - size / 2,
			size, -- 15
			0,
			size -- 16
		}
	end
	return polys
end
