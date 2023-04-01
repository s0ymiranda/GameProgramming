

Boss = Class{__includes = Entity}

function Boss:init(def)
    Entity.init(self, def)
    self.vulnerableDuration = 0
    self.vulnerableTimer = 0
    self.max_health = self.health
end

function Boss:goVulnerable(duration)
    self.invulnerable = false
    self.vulnerableDuration = duration
    self.vulnerableTimer = 0
end

function Boss:update(dt)

    if not self.invulnerable then
        self.vulnerableTimer = self.vulnerableTimer + dt
        self.flashTimer = 0
        if self.vulnerableTimer > self.vulnerableDuration then
            self.invulnerable = true
            self.vulnerableTimer = 0
            self.vulnerableDuration = 0
        end
    else
        self.flashTimer = self.flashTimer + dt
    end

    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end
