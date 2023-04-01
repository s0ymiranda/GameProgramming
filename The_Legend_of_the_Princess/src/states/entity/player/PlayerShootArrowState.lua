--[[
    ISPPJ1 2023
    Study Case: The Legend of the Princess (ARPG)

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the class PlayerShootArrowState.
]]
PlayerShootArrowState = Class{__includes = BaseState}

function PlayerShootArrowState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
    self.bow = GameObject(
        GAME_OBJECT_DEFS['bow'], self.player.x + self.player.width / 4.4, self.player.y
    )
    if player.direction == 'left' then
        self.bow.state = 'left'
        self.bow.x = self.player.x - self.player.width / 2
    elseif player.direction == 'right' then
        self.bow.state = 'right'
    elseif player.direction == 'down' then
        self.bow.state = 'down'
        self.bow.x = self.player.x - 3
        self.bow.y = self.player.y + self.player.height / 4
    elseif player.direction == 'up' then
        self.bow.state = 'up'
        self.bow.x = self.player.x - 3
        self.bow.y = self.player.y - self.player.height / 4
    end

    self.charging = true

    Timer.after(0.5,function() self.charging = false end)

    self.player:changeAnimation('idle-' .. self.player.direction)
end

function PlayerShootArrowState:update(dt)
    if not self.charging then
        local arrow = nil

        if self.bow.state == "up" then
            arrow = GameObject(
                GAME_OBJECT_DEFS['arrow_y'], self.player.x + self.player.width / 4.4, self.player.y
            )
        elseif self.bow.state == "right" then
            arrow = GameObject(
                GAME_OBJECT_DEFS['arrow_x'], self.player.x + self.player.width / 4.4, self.player.y + 7
            )
            arrow.state = 'right'
        elseif self.bow.state == "left" then
            arrow = GameObject(
                GAME_OBJECT_DEFS['arrow_x'], self.player.x + self.player.width / 4.4, self.player.y  + 7
            )
        elseif self.bow.state == "down" then
            arrow = GameObject(
                GAME_OBJECT_DEFS['arrow_y'], self.player.x + self.player.width / 4.4, self.player.y
            )
            arrow.state = 'down'
        end

        table.insert(self.dungeon.currentRoom.projectiles, Projectile(arrow, self.player.direction))
        self.player:changeState('idle')
        
        self.bow = nil
    end
end

function PlayerShootArrowState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(TEXTURES[anim.texture], FRAMES[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
    self.bow:render(0, 0)
end