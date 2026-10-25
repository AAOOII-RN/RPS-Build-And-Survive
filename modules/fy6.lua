local FY6 = {}

function FY6:new(gx, gy, mtr)
	local o = {}
	setmetatable(o, { __index = self })
	love.physics.setMeter(mtr or 64)
	o.world = love.physics.newWorld(gx or 0, gy or 0)
	o.object = {}
	return o
end

function FY6:newRect(id, x, y, w, h, type)
	self.object[id] = {}
	self.object[id].class = "Rect"
	self.object[id].body = love.physics.newBody(self.world, x + w / 2, y + h / 2, type)
	self.object[id].x = x
	self.object[id].y = y
	self.object[id].width = w
	self.object[id].height = h
	self.object[id].shape = love.physics.newRectangleShape(w, h)
	self.object[id].fixture = love.physics.newFixture(self.object[id].body, self.object[id].shape)
	return self.object[id]
end

function FY6:newCirc(id, x, y, r, type)
	self.object[id] = {}
	self.object[id].class = "Circle"
	self.object[id].body = love.physics.newBody(self.world, x, y, type)
	self.object[id].x = x
	self.object[id].y = y
	self.object[id].rad = r
	self.object[id].shape = love.physics.newCircleShape(r)
	self.object[id].fixture = love.physics.newFixture(self.object[id].body, self.object[id].shape)
	return self.object[id]
end

function FY6:newPoly(id, points, type)
	local midpointX, midpointY = 0, 0
	local vertexCount = #points / 2
	for i = 1, #points, 2 do
		midpointX = midpointX + points[i]
		midpointY = midpointY + points[i + 1]
	end
	midpointX = midpointX / vertexCount
	midpointY = midpointY / vertexCount

	local localPoints = {}
	for i = 1, #points, 2 do
		localPoints[i] = points[i] - midpointX
		localPoints[i + 1] = points[i + 1] - midpointY
	end

	self.object[id] = {}
	self.object[id].class = "Polygon"
	self.object[id].body = love.physics.newBody(self.world, midpointX, midpointY, type)
	self.object[id].x = midpointX
	self.object[id].y = midpointY
	self.object[id].shape = love.physics.newPolygonShape(localPoints)
	self.object[id].fixture = love.physics.newFixture(self.object[id].body, self.object[id].shape)
	return self.object[id]
end

function FY6:setScreenBorder()
	local ww, wh = love.graphics.getDimensions()
	self:newRect("FY6_Border1", -30, 0, 30, wh)
	self:newRect("FY6_Border2", 0, -30, ww, 30)
	self:newRect("FY6_Border3", ww, 0, 30, wh)
	self:newRect("FY6_Border4", 0, wh, ww, 30)
end

function FY6:deleteObject(id)
	if not self.object[id].body:isDestroyed() then
		self.object[id].body:destroy()
		self.object[id] = nil
	end
end

function FY6:update(dt)
	self.world:update(dt)
	for id, obj in pairs(self.object) do
		if not obj.body:isDestroyed() then
			if obj.class == "Rect" or obj.class == "Circle" then
				obj.x = obj.body:getX()
				obj.y = obj.body:getY()
			end
			if obj.class == "Polygon" then
				obj.x = obj.body:getX()
				obj.y = obj.body:getY()
			end
		end
	end
end

function FY6:draw()
	love.graphics.setColor(0, 1, 0)
	love.graphics.setNewFont()
	for id, obj in pairs(self.object) do
		if not obj.body:isDestroyed() then
			if obj.class == "Rect" then
				love.graphics.polygon("line", obj.body:getWorldPoints(obj.shape:getPoints()))
			elseif obj.class == "Circle" then
				love.graphics.circle("line", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
			elseif obj.class == "Polygon" then
				love.graphics.polygon("line", obj.body:getWorldPoints(obj.shape:getPoints()))
			end
			love.graphics.print("ID: " .. id, obj.body:getX(), obj.body:getY())
		end
	end
	love.graphics.setColor(1, 1, 1)
end

return FY6
