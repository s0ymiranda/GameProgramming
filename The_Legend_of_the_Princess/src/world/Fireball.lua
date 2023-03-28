--[[
    ISPPJ1 2023
    Study Case: The Legend of the Princess (ARPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by Alejandro Mujica (alejandro.j.mujic4@gmail.com) for teaching purpose.

    This file contains the class Fireball.
]]
Fireball = Class{}

function Fireball:init(caster,target)
    self.caster = caster
    self.target = target
    self.x = caster.x
    self.y = caster.y

    self.active = false
end

function Fireball:update()

    if self.active and self:collides(self.target) and not self.target.invulnerable then
        SOUNDS['hit-player']:play()
        self.target:damage(2)
        self.target:goInvulnerable(1.5)
        self.active = false
    end

    if not self.active then
        self.x = self.caster.x
        self.y = self.caster.y
    end

end

function Fireball:Shoot()

    self.active = true

    Timer.tween(4, {
        [self] = {
            x = self.target.x,
            y = self.target.y - 8
        }
    })
    Timer.after(4,function() self.active = false end)

end

function Fireball:render()

    local texture = TEXTURES['fire_ball']

    local quads = FRAMES['fire_ball']

    if self.active then
        love.graphics.draw(texture ,quads[1], self.x, self.y)
    end

    love.graphics.setColor(love.math.colorFromBytes(255, 0, 255, 255))
    love.graphics.rectangle('line', self.x, self.y, 16, 16)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))

end

function Fireball:collides(target)
    return not (self.x + 16 < target.x or self.x > target.x + target.width or
                self.y + 16 < target.y or self.y > target.y + target.height)
end