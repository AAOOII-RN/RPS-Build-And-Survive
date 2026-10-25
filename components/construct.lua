local CONSTRUCT = {}

local o = {}
function CONSTRUCT:new()
	setmetatable(o, { __index = self })
	-- {rock, paper, scissor, type}
	o.blocks = {
		{
			rock = 1,
			paper = 0,
			scissor = 0,
			x = Ww / 4,
			y = Wh / 2,
			vx = -100 + math.random() * 200,
			vy = -100 + math.random() * 200,
			type = "basic",
		},
		{
			rock = 0,
			paper = 1,
			scissor = 0,
			x = Ww / 4,
			y = Wh / 2,
			vx = -100 + math.random() * 200,
			vy = -100 + math.random() * 200,
			type = "basic",
		},
		{
			rock = 0,
			paper = 0,
			scissor = 1,
			x = Ww / 4,
			y = Wh / 2,
			vx = -100 + math.random() * 200,
			vy = -100 + math.random() * 200,
			type = "basic",
		},
	}
	return o
end

function CONSTRUCT:update(dt)
	for _, obj in pairs(self.blocks) do
		obj.x = obj.x + obj.vx * dt
		obj.y = obj.y + obj.vy * dt

		-- Barrier
		if obj.x - 37.5 <= 0 then
			obj.vx = 0.95 * obj.vx + 100
		end
		if obj.y - 37.5 <= 0 then
			obj.vy = 0.95 * obj.vy + 100
		end
		if obj.x + 37.5 >= Ww then
			obj.vx = 0.95 * obj.vx - 100
		end
		if obj.y + 37.5 >= Wh then
			obj.vy = 0.95 * obj.vy - 100
		end
	end
end

function CONSTRUCT:draw()
	love.graphics.setColor(Pal.bg)
	love.graphics.rectangle("fill", 0, 0, Ww, Wh)

	-- "&" design
	love.graphics.setColor(Pal.bg1)
	local cells = 10
	for x = 1, cells do
		for y = 1, cells do
			love.graphics.print(
				"&",
				(x - 0.5 - math.fmod(y, 2) * 0.5) * Ww / cells,
				(y - 0.5) * Ww / cells,
				math.sin(x + Ticker) * math.cos(y + Ticker) * math.pi * 23 / 180,
				1,
				1,
				Font:getWidth("&") / 2,
				Font:getHeight() / 2
			)
		end
	end

	-- Blocks
	for _, obj in pairs(o.blocks) do
		local max = math.max(obj.rock, math.max(obj.paper, obj.scissor))
		if obj.rock - max == 0 then
			love.graphics.setColor(Pal.red)
		elseif obj.paper - max == 0 then
			love.graphics.setColor(Pal.yellow)
		elseif obj.scissor - max == 0 then
			love.graphics.setColor(Pal.blue)
		end
		love.graphics.rectangle("fill", obj.x - 37.5, obj.y - 37.5, 75, 75, 4)

		love.graphics.setColor(1, 1, 1, 1)
		if obj.rock - max == 0 then
			love.graphics.draw(
				Images.rock,
				obj.x,
				obj.y,
				0,
				60 / Images.rock:getWidth(),
				60 / Images.rock:getWidth(),
				Images.rock:getWidth() / 2,
				Images.rock:getHeight() / 2
			)
		elseif obj.paper - max == 0 then
			love.graphics.draw(
				Images.paper,
				obj.x,
				obj.y,
				0,
				60 / Images.paper:getWidth(),
				60 / Images.paper:getWidth(),
				Images.paper:getWidth() / 2,
				Images.paper:getHeight() / 2
			)
		elseif obj.scissor - max == 0 then
			love.graphics.draw(
				Images.scissor,
				obj.x,
				obj.y,
				0,
				60 / Images.scissor:getWidth(),
				60 / Images.scissor:getWidth(),
				Images.scissor:getWidth() / 2,
				Images.scissor:getHeight() / 2
			)
		end
	end
end

return CONSTRUCT
