
BossShootFireballState = Class{__includes = BaseState}

function BossShootFireballState:init(boss, projectiles, player)
    self.boss = boss
    self.player = player
    self.projectiles = projectiles
    self.fireball = GameObject(
        GAME_OBJECT_DEFS['Fireball'], self.boss.x -2, self.boss.y + self.boss.height/2
    )
    -- self.fireball = GameObject(
    --     GAME_OBJECT_DEFS['Fireball'], self.boss.x -20, self.boss.y -20
    -- )
    -- if player.direction == 'left' then
    --     self.bow.state = 'left'
    --     self.bow.x = self.player.x - self.player.width / 2
    -- elseif player.direction == 'right' then
    --     self.bow.state = 'right'
    -- elseif player.direction == 'down' then
    --     self.bow.state = 'down'
    --     self.bow.x = self.player.x - 3
    --     self.bow.y = self.player.y + self.player.height / 4
    -- elseif player.direction == 'up' then
    --     self.bow.state = 'up'
    --     self.bow.x = self.player.x - 3
    --     self.bow.y = self.player.y - self.player.height / 4
    -- end

    self.boss:changeAnimation('idle-down')
    
    self.charging = true

    Timer.after(0.6,function() self.charging = false end)

end

function BossShootFireballState:update(dt)
    if not self.charging then
        table.insert(self.projectiles, FireBallProjectile(self.fireball, self.player))
        self.boss:changeState('idle')
    end
end

function BossShootFireballState:render()
    local anim = self.boss.currentAnimation
    love.graphics.draw(TEXTURES[anim.texture], FRAMES[anim.texture][anim:getCurrentFrame()],
        math.floor(self.boss.x - self.boss.offsetX), math.floor(self.boss.y - self.boss.offsetY))
    self.fireball:render(0, 0)
end