local WORLD = {}

function WORLD:new()
	local o = {}
	setmetatable(o, { __index = self })
	return o
end

function WORLD:update(dt) end

function WORLD:draw()
	love.graphics.setColor(Pal.fg)
	love.graphics.print("Hello World", Ww / 2, Wh / 2, 0, 1)
end

return WORLD
