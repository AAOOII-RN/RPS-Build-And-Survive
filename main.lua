function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	math.randomseed(1792782602 - os.time())
	SectionMidpoint = 0.05
	InteractingSectionMidpoint = false
	Ww, Wh = love.graphics.getDimensions()
	Ticker = 0
	Font = love.graphics.setNewFont("assets/fonts/Baloo2-Medium.ttf", 100)

	-- Modules
	Pal = require("modules.palette")

	-- Components
	Section = require("components.two_sections"):new()
	World = require("components.world"):new()
	Construct = require("components.construct"):new()

	-- collections
	Cursor = {
		arrow = love.mouse.getSystemCursor("arrow"),
		sizens = love.mouse.getSystemCursor("sizens"),
	}
	Images = {
		rock = love.graphics.newImage("assets/img/rock.png"),
		paper = love.graphics.newImage("assets/img/paper.png"),
		scissor = love.graphics.newImage("assets/img/scissor.png"),
	}
end

function love.update(dt)
	Ticker = Ticker + dt

	-- modules
	-- update other files
	Section:update(dt)
	World:update(dt)
	Construct:update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(Pal.bg1)
	love.graphics.setFont(Font)
	Section:topSection()
	Section:bottomSection()
	love.graphics.setLineWidth(1)
end
