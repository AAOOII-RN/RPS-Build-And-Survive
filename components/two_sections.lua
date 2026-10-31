local SECTION = {}

local o = {}
function SECTION:new()
	o.margin = 10
	setmetatable(o, { __index = self })
	return o
end

function SECTION:update(dt)
	-- Interacting with the section midpoint
	if
		(
			love.mouse.getY() >= (Wh - 20) * SectionMidpoint - 10
			and love.mouse.getY() <= (Wh - 20) * SectionMidpoint + 10
		) or InteractingSectionMidpoint
	then
		love.mouse.setCursor(Cursor.sizens)
		if love.mouse.isDown(1) then
			SectionMidpointLerp = love.mouse.getY() / Wh
			InteractingSectionMidpoint = true
		else
			InteractingSectionMidpoint = false
		end
	else
		love.mouse.setCursor(Cursor.arrow)
	end

	SectionMidpoint = LERP(SectionMidpoint, SectionMidpointLerp, 0.2)

	-- Section Midsection limits
	SectionMidpoint = math.min(math.max(0.015, SectionMidpoint), 0.985)
	SectionMidpointLerp = math.min(math.max(0.03, SectionMidpointLerp), 0.97)
end

local function topSectionStencil()
	love.graphics.rectangle(
		"fill",
		o.margin,
		o.margin,
		Ww - o.margin * 2,
		(Wh - o.margin * 2) * SectionMidpoint - o.margin,
		8
	)
end

local function bottomSectionStencil()
	love.graphics.rectangle(
		"fill",
		o.margin,
		(Wh - o.margin * 2) * SectionMidpoint + o.margin,
		Ww - o.margin * 2,
		(Wh - o.margin * 2) * (1 - SectionMidpoint),
		8
	)
end

function SECTION:topSection()
	love.graphics.setLineWidth(4)
	love.graphics.stencil(topSectionStencil, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	World:draw()
	love.graphics.setStencilTest()
	love.graphics.setColor(Pal.yellow)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line", 10, 10, Ww - 20, (Wh - 20) * SectionMidpoint - 10, 8)
end

function SECTION:bottomSection()
	love.graphics.setLineWidth(4)
	love.graphics.stencil(bottomSectionStencil, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	Construct:draw()
	love.graphics.setStencilTest()
	love.graphics.setColor(Pal.green)
	love.graphics.rectangle("line", 10, (Wh - 20) * SectionMidpoint + 10, Ww - 20, (Wh - 20) * (1 - SectionMidpoint), 8)
	love.graphics.setLineWidth(4)
end

return SECTION
