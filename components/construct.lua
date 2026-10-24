local CONSTRUCT = {}

local o = {}
function CONSTRUCT:new()
	setmetatable(o, { __index = self })
	return o
end

function CONSTRUCT:update(dt) end

function CONSTRUCT:draw()
	love.graphics.setColor(Pal.bg)
	love.graphics.rectangle("fill", 0, 0, Ww, Wh)
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
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(
		Images.rock,
		1 * Ww / 4,
		Wh / 2,
		0,
		200 / Images.rock:getWidth(),
		200 / Images.rock:getHeight(),
		Images.rock:getWidth() / 2,
		Images.rock:getHeight() / 2
	)
	love.graphics.draw(
		Images.paper,
		2 * Ww / 4,
		Wh / 2,
		0,
		200 / Images.rock:getWidth(),
		200 / Images.rock:getHeight(),
		Images.rock:getWidth() / 2,
		Images.rock:getHeight() / 2
	)

	love.graphics.draw(
		Images.scissor,
		3 * Ww / 4,
		Wh / 2,
		0,
		200 / Images.rock:getWidth(),
		200 / Images.rock:getHeight(),
		Images.rock:getWidth() / 2,
		Images.rock:getHeight() / 2
	)
end

return CONSTRUCT
