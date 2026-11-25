local CONSTRUCT = {}

local o = {}
function CONSTRUCT:new()
  setmetatable(o, { __index = self })

  o.firstChoice = ""
  o.mode = "#" -- # = Idling, & = Combining, ? = Observing
  o.modeCooldownBase = 0.15
  o.modeCooldown = o.modeCooldownBase
  -- boid brain settings
  o.protectiveRange = 100
  o.seperation = 0.5
  o.friction = 0.01

  -- {rock, paper, scissor, x, y, vx, vy, type}
  o.blocks = {}
  --[[
  o.blocks["Rock"] = {
    rock = 1,
    paper = 0,
    scissor = 0,
    x = math.random() * Ww,
    y = math.random() * Wh,
    vx = (-1 + math.random() * 2) * 1,
    vy = (-1 + math.random() * 2) * 1,
    btn = Btnui:newRect("Baby" .. 1, 0, 0, 75, 75, false),
    weary = math.random(8, 99),
  }
  o.blocks["Paper"] = {
    rock = 0,
    paper = 1,
    scissor = 0,
    x = math.random() * Ww,
    y = math.random() * Wh,
    vx = (-1 + math.random() * 2) * 1,
    vy = (-1 + math.random() * 2) * 1,
    btn = Btnui:newRect("Baby" .. 2, 0, 0, 75, 75, false),
    weary = math.random(8, 99),
  }
  o.blocks["Scissor"] = {
    rock = 0,
    paper = 0,
    scissor = 1,
    x = math.random() * Ww,
    y = math.random() * Wh,
    vx = (-1 + math.random() * 2) * 1,
    vy = (-1 + math.random() * 2) * 1,
    btn = Btnui:newRect("Baby" .. 3, 0, 0, 75, 75, false),
    weary = math.random(8, 99),
  }
  ]]

  for i = 1, 2 do
    local rockTrait = math.random()
    local paperTrait = math.random()
    local scissorTrait = math.random()
    local sum = rockTrait + paperTrait + scissorTrait
    local block = {
      rock = rockTrait / sum,
      paper = paperTrait / sum,
      scissor = scissorTrait / sum,
      x = math.random() * Ww,
      y = math.random() * Wh,
      vx = (-1 + math.random() * 2) * 1,
      vy = (-1 + math.random() * 2) * 1,
      btn = Btnui:newRect("Baby" .. i, 0, 0, 75, 75, false),
      weary = math.random(8, 99),
    }
    o.blocks["Baby_" .. i] = block
  end
  return o
end

function CONSTRUCT:taskbar()
  love.graphics.setColor(fcv("red", 1))
  love.graphics.rectangle("fill", 65, Wh - 65 - 75, 75, 75, 10)
end

function CONSTRUCT:taskbarUpdate(dt, mx, my) end

function CONSTRUCT:update(dt)
  local mx, my = love.mouse.getPosition()
  self.modeCooldown = math.max(self.modeCooldown - dt, 0)

  for _, obj in pairs(self.blocks) do
    -- Update positions
    obj.x = obj.x + obj.vx * dt
    obj.y = obj.y + obj.vy * dt

    -- Update Btnui
    obj.btn.x = obj.x - 37.5
    obj.btn.y = obj.y - 37.5

    -- Seperation
    local close = { dx = 0, dy = 0 }
    for _, adj in pairs(self.blocks) do
      if math.sqrt((adj.x - obj.x) ^ 2 + (adj.y - obj.y) ^ 2) < self.protectiveRange then
        close.dx = close.dx + obj.x - adj.x
        close.dy = close.dy + obj.y - adj.y
      end
    end
    obj.vx = obj.vx * (1 - self.friction) + close.dx * self.seperation
    obj.vy = obj.vy * (1 - self.friction) + close.dy * self.seperation

    -- Repel blocks away from the bottom-left corner
    if math.sqrt((10 - obj.x) ^ 2 + (Wh - 10 - obj.y) ^ 2) < 200 + 53 then
      obj.vx = obj.vx + obj.x - 10
      obj.vy = obj.vy + obj.y - (Wh - 10)
    end

    -- Barrier
    if obj.x - 37.5 <= 0 then
      obj.vx = obj.vx * 0.9 + 50
    end
    if obj.y - 37.5 <= 0 then
      obj.vy = obj.vy * 0.9 + 50
    end
    if obj.x + 37.5 >= Ww then
      obj.vx = obj.vx * 0.9 - 50
    end
    if obj.y + 37.5 >= Wh then
      obj.vy = obj.vy * 0.9 - 50
    end
  end

  -- The selected block will follow cursor
  if self.firstChoice ~= "" then
    self.blocks[self.firstChoice].vx = self.blocks[self.firstChoice].vx * 0.9
        + mx
        - 80
        - self.blocks[self.firstChoice].x
    self.blocks[self.firstChoice].vy = self.blocks[self.firstChoice].vy * 0.9
        + my
        - 80
        - self.blocks[self.firstChoice].y
  end

  self:taskbarUpdate(dt, mx, my)
end

function CONSTRUCT:mousepressed(mx, my, button)
  if self.modeCooldown == 0 then
    -- Search for every block and their properties
    for id, obj in pairs(self.blocks) do
      -- If left-click and "Idling" mode, hovering a block,
      -- and there's nothing selected yet -> select that block
      -- and switch to "Combining" mode
      if button == 1 and Btnui:isHovered(obj.btn.name, mx, my) then
        if self.mode == "#" and self.firstChoice == "" then
          self.firstChoice = id
          self.mode = "&"
        elseif self.mode == "&" and self.firstChoice ~= "" then
          -- Do a devil's tango
          local r = (self.blocks[self.firstChoice].rock * 0.6 + obj.rock * 0.4) / 2 * (0.7 + math.random() * 0.6)
          local p = (self.blocks[self.firstChoice].paper * 0.6 + obj.paper * 0.4)
              / 2
              * (0.7 + math.random() * 0.6)
          local s = (self.blocks[self.firstChoice].scissor * 0.6 + obj.scissor * 0.4)
              / 2
              * (0.7 + math.random() * 0.6)
          local sum = r + p + s
          local baby = {
            rock = r / sum,
            paper = p / sum,
            scissor = s / sum,
            x = (self.blocks[self.firstChoice].x + obj.x) / 2 + math.random() * 0.01,
            y = (self.blocks[self.firstChoice].y + obj.y) / 2 + math.random() * 0.01,
            vx = (self.blocks[self.firstChoice].vx + obj.vx) / 2,
            vy = (self.blocks[self.firstChoice].vy + obj.vy) / 2,
            btn = Btnui:newRect(
              "baby" .. math.floor(Ticker * 10000),
              (self.blocks[self.firstChoice].x + obj.x) / 2 - 37.5,
              (self.blocks[self.firstChoice].y + obj.y) / 2 - 37.5,
              75,
              75,
              false
            ),
            weary = math.max((self.blocks[self.firstChoice].weary + obj.weary) / 2 + math.random() * 2, 0),
          }
          self.blocks[#self.blocks + 1] = baby
          self.mode = "#"
          self.firstChoice = ""
        elseif self.mode == "?" then
          Btnui.buttons[obj.btn.name] = nil
          self.blocks[id] = nil
          self.mode = "#"
        end
      end
    end
    -- If right-click and "Combining" mode -> switch to "Idling" mode
    if button == 2 then
      if self.mode == "&" then
        self.mode = "#"
        self.firstChoice = ""
      elseif self.mode == "#" then
        self.mode = "?"
      elseif self.mode == "?" then
        self.mode = "#"
      end
    end

    self.modeCooldown = self.modeCooldownBase
  end
end

function CONSTRUCT:draw()
  love.graphics.setColor(Pal.bg)
  love.graphics.rectangle("fill", 0, 0, Ww, Wh)

  -- background design (# = Idling, & = Combining, ? = Observing)
  love.graphics.setColor(Pal.bg1)
  local cells = 10
  for x = 1, cells do
    for y = 1, cells do
      love.graphics.print(
        self.mode,
        (x - 0.5 - math.fmod(y, 2) * 0.5) * Ww / cells,
        (y - 0.5) * Ww / cells,
        math.sin(x + Ticker) * math.cos(y + Ticker) * math.pi * 23 / 180,
        1,
        1,
        Font:getWidth(self.mode) / 2,
        Font:getHeight() / 2
      )
    end
  end

  -- first choice outline
  if self.firstChoice ~= "" then
    love.graphics.setColor(Pal.red)
    love.graphics.rectangle(
      "line",
      self.blocks[self.firstChoice].x - 45,
      self.blocks[self.firstChoice].y - 45,
      90,
      90,
      10
    )
  end

  -- Blocks
  for _, obj in pairs(self.blocks) do
    love.graphics.setColor(1, 1, 1, 1)
    local max = math.max(obj.rock, obj.paper, obj.scissor)
    local total = obj.rock + obj.paper + obj.scissor
    local color = {
      (Pal.red[1] * obj.rock + Pal.yellow[1] * obj.paper + Pal.blue[1] * obj.scissor) / total,
      (Pal.red[2] * obj.rock + Pal.yellow[2] * obj.paper + Pal.blue[2] * obj.scissor) / total,
      (Pal.red[3] * obj.rock + Pal.yellow[3] * obj.paper + Pal.blue[3] * obj.scissor) / total,
    }
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", obj.x - 37.5, obj.y - 37.5, 75, 75, 4)
    love.graphics.setColor(1, 1, 1, 1)

    local tribeShow = Images.rock
    if obj.rock - max == 0 then
      tribeShow = Images.rock
    elseif obj.paper - max == 0 then
      tribeShow = Images.paper
    elseif obj.scissor - max == 0 then
      tribeShow = Images.scissor
    end
    love.graphics.draw(
      tribeShow,
      obj.x,
      obj.y,
      0,
      60 / tribeShow:getWidth(),
      60 / tribeShow:getWidth(),
      tribeShow:getWidth() / 2,
      tribeShow:getHeight() / 2
    )
  end
  self:taskbar()

  -- Block info
  for _, obj in pairs(o.blocks) do
    local mx, my = love.mouse.getPosition()
    local leftInfo = mx + 40 + 250 > Ww
    local upInfo = my + 150 > Wh
    if self.mode == "?" and Btnui:isHovered(obj.btn.name, mx, my) then
      love.graphics.setColor(Pal.bg1)
      love.graphics.rectangle("fill", leftInfo and mx - 40 - 250 or mx + 40, upInfo and my - 150 or my, 250, 150, 10)
      love.graphics.setColor(Pal.fg)
      Font:setLineHeight(0.5)
      love.graphics.print(
        "Rock: "
        .. string.format("%.4f", obj.rock) * 100
        .. "%\n"
        .. "Paper: "
        .. string.format("%.4f", obj.paper) * 100
        .. "%\n"
        .. "Scissor: "
        .. string.format("%.4f", obj.scissor) * 100
        .. "%\n"
        .. "Wearyness: "
        .. string.format("%.2f", obj.weary),
        leftInfo and mx - 30 - 250 or mx + 50,
        upInfo and my - 150 or my,
        0,
        0.3
      )
    end
  end
end

return CONSTRUCT
