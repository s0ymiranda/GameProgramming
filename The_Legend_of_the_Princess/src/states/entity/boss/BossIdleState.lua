BossIdleState = Class{__includes = EntityIdleState}

function BossIdleState:init(boss,player)
    self.entity = boss
    --self.player = player

    self.entity:changeAnimation('idle-' .. self.entity.direction)

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0

    --self.fire_ball = Fireball(boss,player)
end

function BossIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
        if math.random(3) == 1  then
            self.entity:changeState('shoot_fireball')
        end
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('walk')
        end
    end
end


function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(TEXTURES[anim.texture], FRAMES[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    love.graphics.setColor(love.math.colorFromBytes(255, 0, 255, 255))
    love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
end
-- function BossIdleState:Fireball()
--     Timer.tween(
           
--     )