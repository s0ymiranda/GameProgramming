BossIdleState = Class{__includes = EntityIdleState}

function BossIdleState:init(boss)
    self.entity = boss

    self.entity:changeAnimation('idle-' .. self.entity.direction)

    self.waitDuration = 0
    self.waitTimer = 0

end

function BossIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
        if math.random() == 1  then
            self.entity:changeState('shoot_fireball')
        elseif self.entity.health < self.entity.max_health*0.3 and math.random(5) < 3  then
            self.entity:changeState('shoot_fireball')
        end
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('walk')
        end
    end
end

