local CONSTRUCT = {}

local o = {}
function CONSTRUCT:new()
	setmetatable(o, { __index = self })

	o.firstChoice = ""
	o.rightClickCmd = false

	-- boid brain settings
	o.protectiveRange = 75
	o.seperation = 0.5
	o.friction = 0.01

	-- {rock, paper, scissor, x, y, vx, vy, type}
	o.blocks = {}
	for i = 1, 10 do
		local rockTrait = math.random()
		local paperTrait = math.random()
		local scissorTrait = math.random()
		local sum = rockTrait + paperTrait + scissorTrait
		local block = {
			rock = rockTrait / sum,
			paper = paperTrait / sum,
			scissor = scissorTrait / sum,
			x = math.random() * Ww,
			y = math.random() * Wh,
			vx = (-1 + math.random() * 2) * 1,
			vy = (-1 + math.random() * 2) * 1,
			btn = Btnui:newRect("Baby" .. i, 0, 0, 75, 75, false),
			weary = 0,
		}
		o.blocks["Baby_" .. i] = block
	end
	return o
end

function CONSTRUCT:taskbar()
	love.graphics.setColor(fcv("red", 1))
	love.graphics.rectangle("fill", 65, Wh - 65 - 75, 75, 75, 10)
end

function CONSTRUCT:taskbarUpdate(dt, mx, my) end

function CONSTRUCT:update(dt)
	local mx, my = love.mouse.getPosition()
	for _, obj in pairs(self.blocks) do
		-- Update positions
		obj.x = obj.x + obj.vx * dt
		obj.y = obj.y + obj.vy * dt

		-- Update Btnui
		obj.btn.x = obj.x - 37.5
		obj.btn.y = obj.y - 37.5

		-- Seperation
		local close = { dx = 0, dy = 0 }
		for _, adj in pairs(self.blocks) do
			if math.sqrt((adj.x - obj.x) ^ 2 + (adj.y - obj.y) ^ 2) < self.protectiveRange then
				close.dx = close.dx + obj.x - adj.x
				close.dy = close.dy + obj.y - adj.y
			end
		end
		obj.vx = obj.vx * (1 - self.friction) + close.dx * self.seperation
		obj.vy = obj.vy * (1 - self.friction) + close.dy * self.seperation

		-- 150 + 53 = Radius + Block's width * 1.414
		if math.sqrt((10 - obj.x) ^ 2 + (Wh - 10 - obj.y) ^ 2) < 200 + 53 then
			obj.vx = obj.vx + obj.x - 10
			obj.vy = obj.vy + obj.y - (Wh - 10)
		end

		-- Barrier
		if obj.x - 37.5 <= 0 then
			obj.vx = obj.vx + 10
		end
		if obj.y - 37.5 <= 0 then
			obj.vy = obj.vy + 10
		end
		if obj.x + 37.5 >= Ww then
			obj.vx = obj.vx - 10
		end
		if obj.y + 37.5 >= Wh then
			obj.vy = obj.vy - 10
		end
	end

	self:taskbarUpdate(dt, mx, my)
end

function CONSTRUCT:mousepressed(mx, my, button)
	for id, obj in pairs(self.blocks) do
		if button == 1 and Btnui:isHovered(obj.btn.name, mx, my) and not self.rightClickCmd then
			if self.firstChoice == "" then
				self.firstChoice = id
				local choice = self.blocks[self.firstChoice]
			elseif self.blocks[self.firstChoice].btn.name ~= obj.btn.name and self.firstChoice ~= "" then
				-- Make inheritance
				local r = (self.blocks[self.firstChoice].rock * 0.6 + obj.rock * 0.4) / 2 * (0.7 + math.random() * 0.6)
				local p = (self.blocks[self.firstChoice].paper * 0.6 + obj.paper * 0.4)
					/ 2
					* (0.7 + math.random() * 0.6)
				local s = (self.blocks[self.firstChoice].scissor * 0.6 + obj.scissor * 0.4)
					/ 2
					* (0.7 + math.random() * 0.6)
				local sum = r + p + s
				local baby = {
					rock = r / sum,
					paper = p / sum,
					scissor = s / sum,
					x = (self.blocks[self.firstChoice].x + obj.x) / 2 + math.random() * 0.01,
					y = (self.blocks[self.firstChoice].y + obj.y) / 2 + math.random() * 0.01,
					vx = (self.blocks[self.firstChoice].vx + obj.vx) / 2,
					vy = (self.blocks[self.firstChoice].vy + obj.vy) / 2,
					btn = Btnui:newRect(
						"baby" .. math.floor(Ticker * 10000),
						(self.blocks[self.firstChoice].x + obj.x) / 2 - 37.5,
						(self.blocks[self.firstChoice].y + obj.y) / 2 - 37.5,
						75,
						75,
						false
					),
					weary = (self.blocks[self.firstChoice].weary + obj.weary) / 2 - math.random() * 0.01,
				}
				self.blocks[#self.blocks + 1] = baby
				self.firstChoice = ""
			end
		end
		if button == 1 and Btnui:isHovered(obj.btn.name, mx, my) and self.rightClickCmd then
			Btnui.buttons[obj.btn.name] = nil
			table.remove(self.blocks, i)
			self.firstChoice = ""
			self.rightClickCmd = false
		end
	end
	if button == 2 then
		self.firstChoice = ""
		self.rightClickCmd = not self.rightClickCmd
	end
end

function CONSTRUCT:draw()
	love.graphics.setColor(Pal.bg)
	love.graphics.rectangle("fill", 0, 0, Ww, Wh)

	-- background design (# if nothing, & if combining, ? if cmd triggered)
	love.graphics.setColor(Pal.bg1)
	local cells = 10
	for x = 1, cells do
		for y = 1, cells do
			love.graphics.print(
				self.rightClickCmd and "?" or (self.firstChoice ~= "" and "&" or "#"),
				(x - 0.5 - math.fmod(y, 2) * 0.5) * Ww / cells,
				(y - 0.5) * Ww / cells,
				math.sin(x + Ticker) * math.cos(y + Ticker) * math.pi * 23 / 180,
				1,
				1,
				Font:getWidth(self.rightClickCmd and "?" or (self.firstChoice ~= "" and "&" or "#")) / 2,
				Font:getHeight() / 2
			)
		end
	end

	-- first choice outline
	if self.firstChoice ~= "" then
		love.graphics.setColor(Pal.red)
		love.graphics.rectangle(
			"line",
			self.blocks[self.firstChoice].x - 45,
			self.blocks[self.firstChoice].y - 45,
			90,
			90,
			10
		)
	end

	-- Blocks
	for _, obj in pairs(o.blocks) do
		love.graphics.setColor(1, 1, 1, 1)
		local max = math.max(obj.rock, obj.paper, obj.scissor)
		local total = obj.rock + obj.paper + obj.scissor
		local color = {
			(Pal.red[1] * obj.rock + Pal.yellow[1] * obj.paper + Pal.blue[1] * obj.scissor) / total,
			(Pal.red[2] * obj.rock + Pal.yellow[2] * obj.paper + Pal.blue[2] * obj.scissor) / total,
			(Pal.red[3] * obj.rock + Pal.yellow[3] * obj.paper + Pal.blue[3] * obj.scissor) / total,
			1,
		}
		love.graphics.setColor(color)
		love.graphics.rectangle("fill", obj.x - 37.5, obj.y - 37.5, 75, 75, 4)
		love.graphics.setColor(1, 1, 1, 1)

		local tribeShow = Images.rock
		if obj.rock - max == 0 then
			tribeShow = Images.rock
		elseif obj.paper - max == 0 then
			tribeShow = Images.paper
		elseif obj.scissor - max == 0 then
			tribeShow = Images.scissor
		end
		love.graphics.draw(
			tribeShow,
			obj.x,
			obj.y,
			0,
			60 / tribeShow:getWidth(),
			60 / tribeShow:getWidth(),
			tribeShow:getWidth() / 2,
			tribeShow:getHeight() / 2
		)
	end
	self:taskbar()

	-- Block info
	for _, obj in pairs(o.blocks) do
		local mx, my = love.mouse.getPosition()
		local leftInfo = mx + 40 + 250 > Ww
		if self.rightClickCmd and Btnui:isHovered(obj.btn.name, mx, my) then
			love.graphics.setColor(Pal.bg1)
			love.graphics.rectangle("fill", leftInfo and mx - 40 - 250 or mx + 40, my, 250, 120, 10)
			love.graphics.setColor(Pal.fg)
			love.graphics.print(
				"Rock: " .. string.format("%.4f", obj.rock) * 100 .. "%",
				leftInfo and mx - 30 - 250 or mx + 50,
				my,
				0,
				0.3
			)
			love.graphics.print(
				"Paper: " .. string.format("%.4f", obj.paper) * 100 .. "%",
				leftInfo and mx - 30 - 250 or mx + 50,
				my + Font:getHeight() * 0.15,
				0,
				0.3
			)
			love.graphics.print(
				"Scissor: " .. string.format("%.4f", obj.scissor) * 100 .. "%",
				leftInfo and mx - 30 - 250 or mx + 50,
				my + Font:getHeight() * 0.3,
				0,
				0.3
			)
			love.graphics.print(
				"Wearyness: " .. string.format("%.4f", obj.weary) * 100 .. "%",
				leftInfo and mx - 30 - 250 or mx + 50,
				my + Font:getHeight() * 0.45,
				0,
				0.3
			)
		end
	end
end

return CONSTRUCT
