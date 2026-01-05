function love.load()
    -- window
    love.window.setMode(800, 600)
    love.window.setTitle("Orb Hunt")
    canvas = love.graphics.newCanvas()

    shader = love.graphics.newShader("shaders/darkness.frag")
    glitch = love.graphics.newShader("shaders/glith.frag")


    -- player
    player = {
        x = 400,
        y = 300,
        size = 20,
        speed = 200
    }

    -- map
    map = {
        x = 50,
        y = 50,
        w = 700,
        h = 500
    }

    -- orbs
    orbs = {}
    collected = 0
    for i = 1, 5 do
        table.insert(orbs, {
            x = math.random(map.x + 20, map.x + map.w - 20),
            y = math.random(map.y + 20, map.y + map.h - 20),
            r = 8,
            taken = false
        })
    end

    -- monstrum
    monster = {
        x = 100,
        y = 100,
        size = 25,
        speed = 120,
        active = false
    }

    camera = {
        scale = 3
    }

    awakenTime = 6 
    timer = 0

    gameState = "play" -- play / win / lose

    maxFearDistance = 300 -- kdy se začne efekt zapínat
    glitchStrength = 0
end

function love.update(dt)
    if gameState ~= "play" then return end

    timer = timer + dt
    if timer >= awakenTime then
        monster.active = true
    end

    -- player movement
    if love.keyboard.isDown("w") then player.y = player.y - player.speed * dt end
    if love.keyboard.isDown("s") then player.y = player.y + player.speed * dt end
    if love.keyboard.isDown("a") then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("d") then player.x = player.x + player.speed * dt end

    -- map bounds
    if player.x < map.x or player.x > map.x + map.w
    or player.y < map.y or player.y > map.y + map.h then
        gameState = "lose"
    end

    -- collect orbs
    for _, orb in ipairs(orbs) do
        if not orb.taken then
            local dx = player.x - orb.x
            local dy = player.y - orb.y
            if math.sqrt(dx*dx + dy*dy) < player.size then
                orb.taken = true
                collected = collected + 1
                if collected >= 3 then
                    gameState = "win"
                end
            end
        end
    end

    -- monster movement
    if monster.active then
        local dx = player.x - monster.x
        local dy = player.y - monster.y
        local dist = math.sqrt(dx*dx + dy*dy)

        if dist > 0 then
            monster.x = monster.x + (dx / dist) * monster.speed * dt
            monster.y = monster.y + (dy / dist) * monster.speed * dt
        end

        -- kolize s hráčem
        if dist < monster.size then
            gameState = "lose"
        end
    end
end

function love.draw()
    love.graphics.push()

    love.graphics.clear()

    -- zoom + centrování na hráče
    love.graphics.scale(camera.scale)
    love.graphics.translate(
        -player.x + (400 / camera.scale),
        -player.y + (300 / camera.scale)
    )

    -- border and map
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", map.x, map.y, map.w, map.h)

    -- orbs
    for _, orb in ipairs(orbs) do
        if not orb.taken then
            love.graphics.setColor(0, 1, 1)
            love.graphics.circle("fill", orb.x, orb.y, orb.r)
        end
    end

    -- player
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle(
        "fill",
        player.x - player.size / 2,
        player.y - player.size / 2,
        player.size,
        player.size
    )

    -- monstrum
    if monster.active then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle(
            "fill",
            monster.x - monster.size / 2,
            monster.y - monster.size / 2,
            monster.size,
            monster.size
        )
    end

    love.graphics.setShader(shader)

    shader:send("playerPosition", {player.x, player.y})

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    love.graphics.setShader()


    love.graphics.setColor(1, 1, 1)
    love.graphics.pop()
    -- UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Orby: " .. collected .. "/3", 10, 10)

    if not monster.active then
        love.graphics.print("Monstrum se probudí za: " ..
            math.max(0, math.ceil(awakenTime - timer)), 10, 30)
    end

    if gameState == "win" then
        love.graphics.printf("VÝHRA!", 0, 280, 800, "center")
    elseif gameState == "lose" then
        love.graphics.printf("PROHRA!", 0, 280, 800, "center")
    end

    glitch:send("strength", glitchStrength)
    glitch:send("time", love.timer.getTime())

    love.graphics.setShader(glitch)
    
    love.graphics.setShader()
end
