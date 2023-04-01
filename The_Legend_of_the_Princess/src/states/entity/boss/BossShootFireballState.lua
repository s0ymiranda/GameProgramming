
BossShootFireballState = Class{__includes = BaseState}

function BossShootFireballState:init(boss, projectiles, player)
    self.boss = boss
    self.player = player
    self.projectiles = projectiles
    self.fireball = GameObject(
        GAME_OBJECT_DEFS['Fireball'], self.boss.x -3, self.boss.y + self.boss.height/2
    )
    self.boss:changeAnimation('idle-down')
    
    self.charging = true

    Timer.after(0.2,function() self.fireball.state = 'handAnim2' end)
    Timer.after(0.4,function() self.fireball.state = 'handAnim3' end)
    Timer.after(0.5,function() self.fireball.state = 'shoot' end)
    Timer.after(0.6,function() self.charging = false end)

end

function BossShootFireballState:update(dt)
    if not self.charging then
        table.insert(self.projectiles, FireBallProjectile(self.fireball, self.player))
        SOUNDS['flame']:play()
        self.boss:changeState('idle')
        self.fireball = nil
    end
end

function BossShootFireballState:render()
    local anim = self.boss.currentAnimation
    love.graphics.draw(TEXTURES[anim.texture], FRAMES[anim.texture][anim:getCurrentFrame()],
        math.floor(self.boss.x - self.boss.offsetX), math.floor(self.boss.y - self.boss.offsetY))
    self.fireball:render(0, 0)
end