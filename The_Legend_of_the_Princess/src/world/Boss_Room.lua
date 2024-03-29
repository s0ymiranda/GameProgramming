
Boss_Room = Class{__includes = Room}

function Boss_Room:init(player)

    self.player = player

    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self:generateWallsAndFloors()

    self.entities = {}
    self:generateEntities()

    self.doorways = {}

    if player.direction == 'left' then
        table.insert(self.doorways, Doorway('right', false, self))
    elseif player.direction == 'right' then
        table.insert(self.doorways, Doorway('left', false, self))
    elseif player.direction == 'down' then
        table.insert(self.doorways, Doorway('top', false, self))
    else
        table.insert(self.doorways, Doorway('bottom', false, self))
    end

    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y


    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0

    self.projectiles = {}

    SOUNDS['dungeon-music']:stop()

    SOUNDS['boss-music']:setLooping(true)
    SOUNDS['boss-music']:play()

    self.boss_bar = ProgressBar {
        x = 0,
        y = 0,
        width = 32,
        height = 3,
        color = {r = 189, g = 32, b = 32},
        value = self.entities[1].health,
        max = self.entities[1].health
    }

end

function Boss_Room:update(dt)

    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.boss_bar:setValue(self.entities[1].health)
    self.boss_bar:setPosition(self.entities[1].x,self.entities[1].y-6)
    
    if self.entities[1].health == 0 then
        self.doorways[1].open = true
        SOUNDS['door']:play()
        SOUNDS['boss-scream']:play()
        SOUNDS['boss-music']:stop()
        SOUNDS['dungeon-music']:setLooping(true)
        SOUNDS['dungeon-music']:play()
    end

    self.player:update(dt)

    local entity = self.entities[1]

    if entity.health < entity.max_health*0.3 and entity.walkSpeed ~= 50 then
        entity.walkSpeed = 50
        SOUNDS['boss-scream']:play()
    end

    if entity.health <= 0 then
        entity.dead = true
    elseif not entity.dead then
        entity:processAI({room = self}, dt)
        entity:update(dt)
    end

    if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
        SOUNDS['hit-player']:play()
        self.player:damage(2)
        self.player:goInvulnerable(1.5)

        if self.player.health == 0 then
            stateMachine:change('game-over')
        end
    end

    for k, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        for e, entity in pairs(self.entities) do
            if projectile.dead then
                break
            end
            if projectile.obj.type == 'fireball' and projectile:collides(self.player) then
                if not self.player.invulnerable then 
                    self.player:damage(8)
                    SOUNDS['hit-player']:play()
                    projectile.dead = true          
                end       
                if self.player.health < 0 then
                    stateMachine:change('game-over')
                end
            elseif not entity.dead and projectile:collides(entity) and projectile.obj.type ~= 'fireball' then
                entity:goVulnerable(3)
                entity:damage(1)
                SOUNDS['hit-enemy']:play()
                projectile.dead = true
            end
        end

        if projectile.dead then
            table.remove(self.projectiles, k)
        end
        if entity.dead and projectile.obj.type == 'fireball' then 
            table.remove(self.projectiles, k)
        end
    end


end

function Boss_Room:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
 
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end


function Boss_Room:generateEntities()
    
    --There is gonna be just the entity boss in the boss room

    local x_boss = 0
    local y_boss = 0
    if self.player.direction == 'left' then
        x_boss = MAP_RENDER_OFFSET_X + TILE_SIZE
        y_boss = VIRTUAL_HEIGHT/2 - 46
    elseif self.player.direction == 'right' then
        x_boss = VIRTUAL_WIDTH - TILE_SIZE * 2 - 32
        y_boss = VIRTUAL_HEIGHT/2 - 46/2
    elseif self.player.direction == 'down' then
        y_boss = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 46
        x_boss = VIRTUAL_WIDTH/2 - 32/2
    else
        y_boss = MAP_RENDER_OFFSET_Y + TILE_SIZE
        x_boss = VIRTUAL_WIDTH/2 - 32/2
    end
    table.insert(self.entities, Boss {
        animations = ENTITY_DEFS['BOSS'].animations,
        walkSpeed = ENTITY_DEFS['BOSS'].walkSpeed or 20,
        x = x_boss,
        y = y_boss,
        width = 32,
        height = 46,
        health = 200
    })

    self.entities[1].stateMachine = StateMachine {
        ['walk'] = function() return BossWalkState(self.entities[1]) end,
        ['idle'] = function() return BossIdleState(self.entities[1]) end,
        ['shoot_fireball'] = function() return BossShootFireballState(self.entities[1],self.projectiles,self.player) end
    }

    self.entities[1]:changeState('walk')

    self.entities[1].invulnerable = true
end


function Boss_Room:generateObjects()
    --in this room there wwill not be any object
end



function Boss_Room:render()

    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(TEXTURES['tiles'], FRAMES['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end


    if not self.entities[1].dead then 
        self.entities[1]:render(self.adjacentOffsetX, self.adjacentOffsetY) 
        self.boss_bar:render() 
    end

    love.graphics.stencil(function()
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE * 2,
            TILE_SIZE * 2 + 6, TILE_SIZE * 3)
        
        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - 6,
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE * 2, TILE_SIZE * 2 + 6, TILE_SIZE * 3)
        
        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
        
        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)

    if self.player then
        self.player:render()
    end

    for k, projectile in pairs(self.projectiles) do
        projectile:render()
    end

    love.graphics.setStencilTest()

end
