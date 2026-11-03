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
		vx = 0,
		vy = 0,
		maxSpeed = 150,
		friction = 0.05,
	}
	setmetatable(o, { __index = self })
	return o
end

function WORLD:update(dt)
	local mx, my = love.mouse.getPosition()
	if love.keyboard.isDown("w") then
		Travel.vy = Travel.vy + dt * 100
	elseif love.keyboard.isDown("s") then
		Travel.vy = Travel.vy - dt * 100
	end
	if love.keyboard.isDown("a") then
		Travel.vx = Travel.vx + dt * 100
	elseif love.keyboard.isDown("d") then
		Travel.vx = Travel.vx - dt * 100
	end
	local speed = math.sqrt(Travel.vx * Travel.vx + Travel.vy * Travel.vy)
	if speed > Travel.maxSpeed then
		local scale = Travel.maxSpeed / speed
		Travel.vx = Travel.vx * scale
		Travel.vy = Travel.vy * scale
	end
	Travel.vx = Travel.vx * (1 - Travel.friction)
	Travel.vy = Travel.vy * (1 - Travel.friction)
	Travel.x = Travel.x + Travel.vx
	Travel.y = Travel.y + Travel.vy

	if
		love.mouse.isDown(1)
		and not InteractingSectionMidpoint
		and my < Wh * SectionMidpoint
		and Construct.firstChoice ~= ""
	then
		local obj = Construct.blocks[Construct.firstChoice]
		local x = math.floor((mx - Travel.x - 6) / self.cellSize + self.worldSize.w / 2) + 1
		local y = math.floor((my - Travel.y - 6) / self.cellSize + self.worldSize.h / 2) + 1
		local total = obj.rock + obj.paper + obj.scissor
		if
			x >= 1 -- is not beyond leftmost border
			and x <= self.worldSize.w -- is not beyond rightmost border
			and y >= 1 -- is not beyond topmost border
			and y <= self.worldSize.h -- is not beyond bottommost border
			and not self.world[x][y] -- is an empty cell
			and obj.weary <= 1 -- is not weary
		then
			self.placedBlocks[x][y] = {
				(Pal.red[1] * obj.rock + Pal.yellow[1] * obj.paper + Pal.blue[1] * obj.scissor) / total,
				(Pal.red[2] * obj.rock + Pal.yellow[2] * obj.paper + Pal.blue[2] * obj.scissor) / total,
				(Pal.red[3] * obj.rock + Pal.yellow[3] * obj.paper + Pal.blue[3] * obj.scissor) / total,
				obj.rock,
				obj.paper,
				obj.scissor,
				100,
			}
		end
	end
end

function WORLD:mousepressed(mx, my, button)
	if button == 1 and not InteractingSectionMidpoint and my < Wh * SectionMidpoint and Construct.firstChoice ~= "" then
		local obj = Construct.blocks[Construct.firstChoice]
		local x = math.floor((mx - Travel.x - 6) / self.cellSize + self.worldSize.w / 2) + 1
		local y = math.floor((my - Travel.y - 6) / self.cellSize + self.worldSize.h / 2) + 1
		if x >= 1 and x <= self.worldSize.w and y >= 1 and y <= self.worldSize.h and not self.world[x][y] then
			obj.weary = obj.weary + math.random() * 0.01
		end
	end
end

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
			if self.world[x][y] == 2 then
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
			if self.placedBlocks[x][y] ~= 0 then
				local pblks = self.placedBlocks[x][y]
				local max = math.max(pblks[4], pblks[5], pblks[6])
				love.graphics.setColor(pblks[1], pblks[2], pblks[3], 1)
				love.graphics.rectangle(
					"fill",
					((x - 1) - self.worldSize.w / 2) * self.cellSize + 6 + Travel.x,
					((y - 1) - self.worldSize.h / 2) * self.cellSize + 6 + Travel.y,
					self.cellSize - 3,
					self.cellSize - 3,
					4
				)
				love.graphics.setColor(1, 1, 1, 1)
				local tribeShow = Images.rock
				if pblks[4] - max == 0 then
					tribeShow = Images.rock
				elseif pblks[5] - max == 0 then
					tribeShow = Images.paper
				elseif pblks[6] - max == 0 then
					tribeShow = Images.scissor
				end
				love.graphics.draw(
					tribeShow,
					((x - 1) - self.worldSize.w / 2) * self.cellSize + 6 + self.cellSize / 2 + Travel.x,
					((y - 1) - self.worldSize.h / 2) * self.cellSize + 6 + self.cellSize / 2 + Travel.y,
					0,
					45 / tribeShow:getWidth(),
					45 / tribeShow:getWidth(),
					tribeShow:getWidth() / 2,
					tribeShow:getHeight() / 2
				)
			end
		end
	end
end

return WORLD
