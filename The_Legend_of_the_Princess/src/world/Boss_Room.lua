--[[
    ISPPJ1 2023
    Study Case: The Legend of the Princess (ARPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by Alejandro Mujica (alejandro.j.mujic4@gmail.com) for teaching purpose.

    This file contains the class Room.
]]
Boss_Room = Class{}

function Boss_Room:init(player)
    -- reference to player for collisions, etc.
    self.player = player

    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self:generateWallsAndFloors()

    -- entities in the room
    self.entities = {}
    self:generateEntities()

    -- game objects in the room
    self.objects = {}
    self:generateObjects()

    -- doorways that lead to other dungeon rooms
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

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0

    -- projectiles
    self.projectiles = {}

    SOUNDS['dungeon-music']:stop()

    SOUNDS['boss-music']:setLooping(true)
    SOUNDS['boss-music']:play()


    -- self.boss_bar = {}
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

    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end
    
    -- Boss Life Bar

    self.boss_bar:setValue(self.entities[1].health)
    self.boss_bar:setPosition(self.entities[1].x,self.entities[1].y-6)

    --self.entities[1].fire_ball:update()
    
    if self.entities[1].health == 0 then
        self.doorways[1].open = true
    end

    self.player:update(dt)

    local entity = self.entities[1]

    -- remove entity from the table if health is <= 0
    if entity.health <= 0 then
        entity.dead = true
        -- whether the entity dropped or not, it is assumed that it dropped
        entity.dropped = true
    elseif not entity.dead then
        entity:processAI({room = self}, dt)
        entity:update(dt)
    end

    -- collision between the player and entities in the room
    if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
        SOUNDS['hit-player']:play()
        self.player:damage(1)
        self.player:goInvulnerable(1.5)

        if self.player.health == 0 then
            stateMachine:change('game-over')
        end
    end

    --NOTA se removio la parte de procesamiento de objetos

    for k, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        -- check collision with entities
        for e, entity in pairs(self.entities) do
            if projectile.dead then
                break
            end
            if projectile.obj.type == 'fireball' and projectile:collides(self.player) then
                if not self.player.invulnerable then 
                    self.player:damage(100000000000)
                    SOUNDS['hit-player']:play()
                    projectile.dead = true             
                end       
                if self.player.health < 0 then
                    stateMachine:change('game-over')
                end
            elseif not entity.dead and projectile:collides(entity) and projectile.obj.type ~= 'fireball' then
                if entity.invulnerable then 
                    Timer.after(3,function() entity.invulnerable = true entity.invulnerableDuration = 100000000 end)
                end
                entity.invulnerable = false
                entity.invulnerableDuration = 0
                entity:damage(1)
                SOUNDS['hit-enemy']:play()
                projectile.dead = true
            end
        end

        if projectile.dead then
            table.remove(self.projectiles, k)
        end
    end

end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
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
            
            -- random left-hand walls, right walls, top, bottom, and floors
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

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Boss_Room:generateEntities()
    
    local type = 'BOSS'
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
        animations = ENTITY_DEFS[type].animations,
        walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

        -- ensure X and Y are within bounds of the map
        x = x_boss,
        y = y_boss,
        -- y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
        --     VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),



        -- x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
        --     VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),

        width = 32,
        height = 46,

        health = 200
    })

    self.entities[1].stateMachine = StateMachine {
        ['walk'] = function() return BossWalkState(self.entities[1]) end,
        ['idle'] = function() return BossIdleState(self.entities[1]) end,
        ['shoot_fireball'] = function() return BossShootFireballState(self.entities[1],self.projectiles,self.player) end
    }

    --self.entities[1].fire_ball = Fireball(self.entities[1],self.player)

    self.entities[1]:changeState('walk')

    self.entities[1].invulnerable = true
    self.entities[1].invulnerableDuration = 10000000 
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Boss_Room:generateObjects()
   
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

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    -- stencil out the door arches so it looks like the player is going through
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

    -- if not self.entities[1].fire_ball == nil then 
    --     self.entities[1].fire_ball:render()
    -- end

    --self.entities[1].fire_ball:render()

    -- Boss Bar
    if self.entities[1].health > 0 then
        self.boss_bar:render()
    end
end
