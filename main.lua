function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	sectionMidpoint = 0.95
	interactingSectionMidpoint = false
	Ww, Wh = love.graphics.getDimensions()
	Ticker = 0
	Font = love.graphics.setNewFont("assets/fonts/Baloo2-Medium.ttf", 100)
	-- Modules
	Pal = require("modules.palette")

	-- Components
	Section = require("components.two_sections"):new()
	World = require("components.world"):new()

	-- arrays
	Cursor = {
		arrow = love.mouse.getSystemCursor("arrow"),
		sizens = love.mouse.getSystemCursor("sizens"),
	}
end

function love.update(dt)
	Ticker = Ticker + dt

	-- Interacting with the section midpoint
	if
		(
			love.mouse.getY() >= (Wh - 20) * sectionMidpoint - 10
			and love.mouse.getY() <= (Wh - 20) * sectionMidpoint + 10
		) or interactingSectionMidpoint
	then
		love.mouse.setCursor(Cursor.sizens)
		if love.mouse.isDown(1) then
			sectionMidpoint = love.mouse.getY() / Wh
			interactingSectionMidpoint = true
		else
			interactingSectionMidpoint = false
		end
	else
		love.mouse.setCursor(Cursor.arrow)
	end

	-- Section Midsection limits
	sectionMidpoint = math.min(math.max(0.05, sectionMidpoint), 0.95)
end

function love.draw()
	love.graphics.setBackgroundColor(Pal.bg)
	Section:topSection()
	Section:bottomSection()
	love.graphics.setLineWidth(1)
end
