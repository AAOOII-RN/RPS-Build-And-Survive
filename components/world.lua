local WORLD = {}

local o = {}
function WORLD:new()
	-- World Generation
	o.worldSeed = math.random(999999999)
	o.worldSize = {
		w = 100,
		h = 100,
	}
	o.cellSize = 60
	o.world = {}
	o.placedBlocks = {}
	for x = 1, o.worldSize.w do
		o.world[x] = {}
		o.placedBlocks[x] = {}
		for y = 1, o.worldSize.h do
			if
				(
						love.math.noise(x / 28, y / 28, o.worldSeed) * 0.55
						+ love.math.noise(x / 21, y / 21, o.worldSeed + 50) * 0.22
						+ love.math.noise(x / 14, y / 14, o.worldSeed + 100) * 0.33
					)
					/ 1
				> 0.55
			then
				o.world[x][y] = 1
			end
			o.placedBlocks[x][y] = 0
		end
	end
	local checkX, checkY = math.random(o.worldSize.w), math.random(o.worldSize.h)
	while o.world[checkX][checkY] == 1 do
		checkX, checkY = math.random(o.worldSize.w), math.random(o.worldSize.h)
	end
	o.world[checkX][checkY] = 2
	local squareSize = o.cellSize - 3
	local squareX = ((checkX - 1) - o.worldSize.w / 2) * o.cellSize + 6
	local squareY = ((checkY - 1) - o.worldSize.h / 2) * o.cellSize + 6

	Travel = {
		x = Ww / 2 - squareX - squareSize / 2,
		y = Wh / 2 - squareY - squareSize / 2,
	}
	setmetatable(o, { __index = self })
	return o
end

function WORLD:update(dt)
	local mx, my = love.mouse.getPosition()
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

	if love.mouse.isDown(1) and not InteractingSectionMidpoint then
		local x = math.floor((mx - Travel.x - 6) / self.cellSize + self.worldSize.w / 2) + 1
		local y = math.floor((my - Travel.y - 6) / self.cellSize + self.worldSize.h / 2) + 1
		if x >= 1 and x <= self.worldSize.w and y >= 1 and y <= self.worldSize.h and not self.world[x][y] then
			self.placedBlocks[x][y] = 2
		end
	end
end

function WORLD:mousepressed(mx, my, button) end

function WORLD:draw()
	love.graphics.setColor(Pal.bg)
	love.graphics.rectangle("fill", 0, 0, Ww, Wh)
	for x = 1, self.worldSize.w do
		for y = 1, self.worldSize.h do
			love.graphics.setColor(Pal.bg2)
			love.graphics.setLineWidth(1)
			love.graphics.rectangle(
				"line",
				((x - 1) - self.worldSize.w / 2) * self.cellSize + 6 + Travel.x,
				((y - 1) - self.worldSize.h / 2) * self.cellSize + 6 + Travel.y,
				self.cellSize - 3,
				self.cellSize - 3,
				4
			)
		end
	end

	for x = 1, self.worldSize.w do
		for y = 1, self.worldSize.h do
			if self.world[x][y] == 1 then
				love.graphics.setColor(Pal.aqua)
				love.graphics.rectangle(
					"fill",
					((x - 1) - self.worldSize.w / 2) * self.cellSize + 6 + Travel.x,
					((y - 1) - self.worldSize.h / 2) * self.cellSize + 6 + Travel.y,
					self.cellSize - 3,
					self.cellSize - 3,
					4
				)
			end
			if self.world[x][y] == 2 or self.placedBlocks[x][y] == 2 then
				love.graphics.setColor(Pal.yellow)
				love.graphics.rectangle(
					"fill",
					((x - 1) - self.worldSize.w / 2) * self.cellSize + 6 + Travel.x,
					((y - 1) - self.worldSize.h / 2) * self.cellSize + 6 + Travel.y,
					self.cellSize - 3,
					self.cellSize - 3,
					4
				)
			end
		end
	end
end

return WORLD
