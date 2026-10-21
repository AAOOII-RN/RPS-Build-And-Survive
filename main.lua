function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	Ww, Wh = love.graphics.getDimensions()
	Ticker = 0
	Font = love.graphics.setNewFont("assets/fonts/Baloo2-Medium.ttf", 100)
	-- Modules
	Pal = require("modules.palette")
end

function love.update(dt)
	Ticker = Ticker + dt
end

function love.draw()
	love.graphics.setBackgroundColor(Pal.bg)
	love.graphics.setColor(Pal.fg)
	love.graphics.print("Hello World", 0, Wh - Font:getHeight() * 0.5, 0, 0.5)
	love.graphics.setColor(Pal.aqua)
	love.graphics.rectangle("fill", Ww / 2 - 50, Wh / 2 - 50, 100, 100, 8)
end
