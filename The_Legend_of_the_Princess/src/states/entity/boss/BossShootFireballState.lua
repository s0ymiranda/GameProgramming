
BossShootFireballState = Class{__includes = BaseState}

function BossShootFireballState:init(boss, dungeon)
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

function BossShootFireballState:update(dt)
    if not self.charging then
        if self.bow.state == "up" then
            self.bow.state = "throw-up"
        elseif self.bow.state == "right" then
            self.bow.state = "throw-right"
        elseif self.bow.state == "left" then
            self.bow.state = "throw-left"
        elseif self.bow.state == "down" then
            self.bow.state = "throw-down"
        end
        table.insert(self.dungeon.currentRoom.projectiles, Projectile(self.bow, self.player.direction))
        self.player:changeState('idle')
    end
end

function BossShootFireballState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(TEXTURES[anim.texture], FRAMES[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
    self.bow:render(0, 0)
end