local CONSTRUCT = {}

local o = {}
function CONSTRUCT:new()
	setmetatable(o, { __index = self })

	o.firstChoice = ""
	o.rightClickCmd = false

	-- boid brain settings
	o.protectiveRange = 75
	o.seperation = 0.5
	o.friction = 0.005

	-- {rock, paper, scissor, x, y, vx, vy, type}
	o.blocks = {
		{
			rock = 1,
			paper = 0,
			scissor = 0,
			x = math.random() * Ww,
			y = math.random() * Wh,
			vx = (-1 + math.random() * 2) * 1,
			vy = (-1 + math.random() * 2) * 1,
			type = "basic",
			btn = Btnui:newRect("BaseRock", 0, 0, 75, 75, false),
		},
		{
			rock = 0,
			paper = 1,
			scissor = 0,
			x = math.random() * Ww,
			y = math.random() * Wh,
			vx = (-1 + math.random() * 2) * 1,
			vy = (-1 + math.random() * 2) * 1,
			type = "basic",
			btn = Btnui:newRect("BasePaper", 0, 0, 75, 75, false),
		},
		{
			rock = 0,
			paper = 0,
			scissor = 1,
			x = math.random() * Ww,
			y = math.random() * Wh,
			vx = (-1 + math.random() * 2) * 1,
			vy = (-1 + math.random() * 2) * 1,
			type = "basic",
			btn = Btnui:newRect("BaseScissor", 0, 0, 75, 75, false),
		},
	}
	for i = 1, 0 do
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
			type = "basic",
			btn = Btnui:newRect("Baby" .. i, 0, 0, 75, 75, false),
		}
		table.insert(o.blocks, block)
	end
	return o
end

function CONSTRUCT:update(dt)
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
end

function CONSTRUCT:mousepressed(mx, my, button)
	for i, obj in ipairs(self.blocks) do
		if button == 1 and Btnui:isHovered(obj.btn.name, mx, my) and not self.rightClickCmd then
			if self.firstChoice == "" then
				self.firstChoice = obj
			elseif self.firstChoice.btn.name ~= obj.btn.name and self.firstChoice ~= "" then
				-- Make inheritance
				local r = (self.firstChoice.rock * 0.6 + obj.rock * 0.4) / 2 * (0.7 + math.random() * 0.6)
				local p = (self.firstChoice.paper * 0.6 + obj.paper * 0.4) / 2 * (0.7 + math.random() * 0.6)
				local s = (self.firstChoice.scissor * 0.6 + obj.scissor * 0.4) / 2 * (0.7 + math.random() * 0.6)
				local sum = r + p + s
				local baby = {
					rock = r / sum,
					paper = p / sum,
					scissor = s / sum,
					x = (self.firstChoice.x + obj.x) / 2,
					y = (self.firstChoice.y + obj.y) / 2,
					vx = (self.firstChoice.vx + obj.vx) / 2,
					vy = (self.firstChoice.vy + obj.vy) / 2,
					type = "basic",
					btn = Btnui:newRect(
						"baby" .. math.floor(Ticker * 10000),
						(self.firstChoice.x + obj.x) / 2 - 37.5,
						(self.firstChoice.y + obj.y) / 2 - 37.5,
						75,
						75,
						false
					),
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

		-- Block info
		local mx, my = love.mouse.getPosition()
		if self.rightClickCmd and Btnui:isHovered(obj.btn.name, mx, my) then
			love.graphics.setColor(Pal.fg)
			love.graphics.print("Rock: " .. string.format("%.4f", obj.rock), mx + 50, my, 0, 0.3)
			love.graphics.print(
				"Paper: " .. string.format("%.4f", obj.paper),
				mx + 50,
				my + Font:getHeight() * 0.15,
				0,
				0.3
			)
			love.graphics.print(
				"Scissor: " .. string.format("%.4f", obj.scissor),
				mx + 50,
				my + Font:getHeight() * 0.3,
				0,
				0.3
			)
		end
	end
end

return CONSTRUCT
