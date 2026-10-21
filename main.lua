function love.load()
	Ticker = 0
end

function love.update(dt)
	Ticker = Ticker + dt
end

function love.draw()
	love.graphics.print("Hello World")
end
