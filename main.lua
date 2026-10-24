function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	math.randomseed(1792782602 - os.time())
	SectionMidpoint = 0.95
	InteractingSectionMidpoint = false
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
			love.mouse.getY() >= (Wh - 20) * SectionMidpoint - 10
			and love.mouse.getY() <= (Wh - 20) * SectionMidpoint + 10
		) or InteractingSectionMidpoint
	then
		love.mouse.setCursor(Cursor.sizens)
		if love.mouse.isDown(1) then
			SectionMidpoint = love.mouse.getY() / Wh
			InteractingSectionMidpoint = true
		else
			InteractingSectionMidpoint = false
		end
	else
		love.mouse.setCursor(Cursor.arrow)
	end

	-- Section Midsection limits
	SectionMidpoint = math.min(math.max(0.05, SectionMidpoint), 0.95)

	-- update other files
	World:update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(Pal.bg)
	Section:topSection()
	Section:bottomSection()
	love.graphics.setLineWidth(1)
end
