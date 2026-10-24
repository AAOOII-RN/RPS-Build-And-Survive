local SECTION = {}

function SECTION:new()
	local o = {}
	setmetatable(o, { __index = self })
	return o
end

local function topSectionStencil()
	love.graphics.rectangle("fill", 10, 10, Ww - 20, (Wh - 20) * SectionMidpoint - 10, 8)
end

local function bottomSectionStencil()
	love.graphics.rectangle("fill", 10, (Wh - 20) * SectionMidpoint + 10, Ww - 20, (Wh - 20) * (1 - SectionMidpoint), 8)
end

function SECTION:topSection()
	love.graphics.setLineWidth(4)
	love.graphics.stencil(topSectionStencil, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	World:draw()
	love.graphics.setStencilTest()
	love.graphics.setColor(Pal.yellow)
	love.graphics.rectangle("line", 10, 10, Ww - 20, (Wh - 20) * SectionMidpoint - 10, 8)
	love.graphics.setLineWidth(4)
end

function SECTION:bottomSection()
	love.graphics.stencil(bottomSectionStencil, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	love.graphics.setStencilTest()
	love.graphics.setColor(Pal.green)
	love.graphics.rectangle("line", 10, (Wh - 20) * SectionMidpoint + 10, Ww - 20, (Wh - 20) * (1 - SectionMidpoint), 8)
	love.graphics.setLineWidth(4)
end

return SECTION
