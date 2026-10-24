local WORLD = {}

function WORLD:new()
	local o = {}

	-- World Generation
	o.worldSeed = math.random(999999999)
	o.worldSize = {
		w = 512,
		h = 512,
	}
	o.cellSize = 45
	o.world = {}
	for x = 1, o.worldSize.w do
		o.world[x] = {}
		for y = 1, o.worldSize.h do
			if
				(love.math.noise(x / 21, y / 21, o.worldSeed) + love.math.noise(x / 14, y / 14, o.worldSeed + 100))
					/ 2
				> 0.55
			then
				o.world[x][y] = 1
			end

			if love.math.noise(x / 21, y / 21, o.worldSeed + 100) > 0.8 then
				o.world[x][y] = o.world[x][y] == 1 and 0 or 1
			end
		end
	end
	Travel = {
		x = 0,
		y = 0,
	}
	setmetatable(o, { __index = self })
	return o
end

function WORLD:update(dt)
	if love.keyboard.isDown("up") then
		Travel.y = Travel.y + dt * 300
	elseif love.keyboard.isDown("down") then
		Travel.y = Travel.y - dt * 300
	end
	if love.keyboard.isDown("left") then
		Travel.x = Travel.x + dt * 300
	elseif love.keyboard.isDown("right") then
		Travel.x = Travel.x - dt * 300
	end
end

function WORLD:draw()
	love.graphics.setColor(Pal.fg)
	love.graphics.print("Hello World", Ww / 2, Wh / 2, 0, 1)
	love.graphics.setColor(Pal.red)
	for x = 1, self.worldSize.w do
		for y = 1, self.worldSize.h do
			if self.world[x][y] == 1 then
				love.graphics.rectangle(
					"fill",
					(x - self.worldSize.w / 2) * self.cellSize + 6 + Travel.x,
					(y - self.worldSize.h / 2) * self.cellSize + 6 + Travel.y,
					self.cellSize - 3,
					self.cellSize - 3,
					4
				)
			end
		end
	end
end

return WORLD
