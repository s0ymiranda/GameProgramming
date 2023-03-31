--[[
    ISPPJ1 2023
    Study Case: The Legend of the Princess (ARPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by Alejandro Mujica (alejandro.j.mujic4@gmail.com) for teaching purpose.

    This file contains the class Boss.
]]
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
    --Entity.update(self, dt)

    if not self.invulnerable then
        self.vulnerableTimer = self.vulnerableTimer + dt
        self.flashTimer = 0
        if self.vulnerableTimer > self.vulnerableDuration then
            self.invulnerable = true
            self.vulnerableTimer = 0
            self.vulnerableDuration = 0
            -- self.flashTimer = 0
        end
    else
        self.flashTimer = self.flashTimer + dt
    end

    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Boss:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

-- function Boss:render()
--     Entity.render(self)
--     -- love.graphics.setColor(love.math.colorFromBytes(255, 0, 255, 255))
--     -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
--     -- love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
-- end
