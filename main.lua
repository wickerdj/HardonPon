HC = require 'HardonCollider'

function on_collide(dt, shape_a, shape_b)
  -- determine which shape is the ball and which the paddle
  local other

  if shape_a == ball then
    other = shape_b
  elseif shape_b == ball then
    other = shape_a
  else
    return
  end

  -- reset on goal
  if other == goalLeft then
    ball.velocity = { x = 100, y = 0 }
    ball:moveTo(400, 300)
  elseif other == goalRight then
    ball.velocity = { x = -100, y = 0 }
    ball:moveTo(400, 300)
  elseif other == borderTop or other == borderBottom then
    -- bounce off top and bottom
    ball.velocity.y = -ball.velocity.y
  else
    -- bounce off paddle
    local px,py = other:center()
    local bx,by = ball:center()
    local dy = by - py
    ball.velocity.x = -ball.velocity.x
    ball.velocity.y = dy

    -- keep the ball at the same speed as before
    local len = math.sqrt(ball.velocity.x^2 + ball.velocity.y^2)
    ball.velocity.x = ball.velocity.x / len * 100
    ball.velocity.y = ball.velocity.y / len * 100
  end
end

function love.load()
  Collider = HC(100, on_collide)

  ball = Collider:addCircle(400, 300, 10)
  paddleLeft = Collider:addRectangle(10, 250, 20, 100)
  paddleRight = Collider:addRectangle(770, 250, 20, 100)

  ball.velocity = {x = -100, y = 0}

  borderTop = Collider:addRectangle(0, -100, 800, 100)
  borderBottom = Collider:addRectangle(0, 600, 800, 100)
  goalLeft = Collider:addRectangle(-100, 0, 100, 600)
  goalRight = Collider:addRectangle(800, 0, 100, 600)
end

function love.update(dt)
  ball:move(ball.velocity.x * dt, ball.velocity.y * dt)

  -- left player movement
  if love.keyboard.isDown('w') then
    paddleLeft:move(0, -100 * dt)
  elseif love.keyboard.isDown('s') then
    paddleLeft:move(0, 100 * dt)
  end

  -- right player movement
  if love.keyboard.isDown('up') then
    paddleRight:move(0, -100 * dt)
  elseif love.keyboard.isDown('down') then
    paddleRight:move(0, 100 * dt)
  end

  -- check for collisions
  Collider:update(dt)
end

function love.draw()
  -- we can also use 'line' instead of 'fill'
  ball:draw('fill', 16) -- approximated circle with 16 edges
  paddleLeft:draw('fill')
  paddleRight:draw('fill')
end
