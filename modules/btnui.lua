local BTNUI = {}

function BTNUI:new()
	local o = { buttons = {} }
	setmetatable(o, { __index = self })
	return o
end

function BTNUI:newRect(id, x, y, w, h, sleep)
	self.buttons[id] = {
		name = id,
		type = "Rect",
		x = x or 0,
		y = y or 0,
		width = w or 0,
		height = h or 0,
		sleep = sleep,
		clicked = false,
	}
	return self.buttons[id]
end

function BTNUI:newCirc(id, x, y, r, sleep)
	self.buttons[id] = {
		name = id,
		type = "Circ",
		x = x or 0,
		y = y or 0,
		rad = r or 0,
		sleep = sleep,
		clicked = false,
	}
	return self.buttons[id]
end

function BTNUI:editBtnRect(id, x, y, w, h, sleep)
	self.buttons[id] = {
		name = self.buttons[id].name,
		type = self.buttons[id].type,
		x = x or self.buttons[id].x,
		y = y or self.buttons[id].y,
		width = w or self.buttons[id].width,
		height = h or self.buttons[id].height,
		sleep = sleep or self.buttons[id].sleep,
		clicked = self.buttons[id].clicked,
	}
	return self.buttons[id]
end

function BTNUI:editBtnCirc(id, x, y, r, sleep)
	self.buttons[id] = {
		name = self.buttons[id].name,
		type = self.buttons[id].type,
		x = x or self.buttons[id].x,
		y = y or self.buttons[id].y,
		rad = r or self.buttons[id].rad,
		sleep = sleep or self.buttons[id].sleep,
		clicked = self.buttons[id].clicked,
	}
	return self.buttons[id]
end

function BTNUI:refresh()
	for _, obj in pairs(self.buttons) do
		obj.x = 0
		obj.y = 0
		if obj.type == "Rect" then
			obj.width = 0
			obj.height = 0
		else
			obj.rad = 0
		end
		obj.sleep = true
	end
end

function BTNUI:isHovered(id, mx, my)
	local obj = self.buttons[id]
	if obj then
		if obj.type == "Rect" then
			return mx >= obj.x and mx <= obj.x + obj.width and my >= obj.y and my <= obj.y + obj.height
		elseif obj.type == "Circ" then
			return obj.type == "Circ" and ((obj.x - mx) ^ 2 + (obj.y - my) ^ 2) ^ 0.5 < obj.rad
		end
	end
end

function BTNUI:draw()
	local old_font = love.graphics.getFont()
	love.graphics.setNewFont(16)
	for id, obj in pairs(self.buttons) do
		if not obj.sleep then
			love.graphics.setColor(1, self:isHovered(id, love.mouse.getX(), love.mouse.getY()) and 1 or 0, 0)
			if obj.type == "Rect" then
				love.graphics.rectangle("line", obj.x, obj.y, obj.width, obj.height)
				love.graphics.print("ID: " .. id, obj.x, obj.y)
			elseif obj.type == "Circ" then
				love.graphics.circle("line", obj.x, obj.y, obj.rad)
				love.graphics.print("ID: " .. id, obj.x, obj.y)
			end
		end
	end
	love.graphics.setFont(old_font)
	love.graphics.setColor(1, 1, 1)
end

return BTNUI
