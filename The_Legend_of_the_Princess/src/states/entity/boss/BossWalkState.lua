
BossWalkState = Class{__includes = EntityWalkState}

function BossWalkState:init(boss)

    self.entity = boss

    self.entity:changeAnimation('walk-down')

    self.moveDuration = 0
    self.movementTimer = 0

    self.bumped = false

end

function BossWalkState:processAI(params, dt)
    local room = params.room
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        elseif math.random(2) == 1  then
                self.entity:changeState('shoot_fireball')
        elseif self.entity.health < self.entity.max_health*0.3 and math.random(5) < 3  then
                self.entity:changeState('shoot_fireball')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end

    self.movementTimer = self.movementTimer + dt
end