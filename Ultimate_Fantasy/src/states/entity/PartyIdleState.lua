--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the class PartyIdleState.
]]
PartyIdleState = Class{__includes = PartyBaseState}

function PartyIdleState:init(party)
    PartyBaseState.init(self, party)
    for k, c in pairs(self.party.characters) do
        c:changeAnimation('idle-' .. c.direction)
    end
end

function PartyIdleState:update(dt)
    if love.keyboard.isDown('left','a') then
        self.party:changeState('walk', {direction = 'left'})
    elseif love.keyboard.isDown('right','d') then
        self.party:changeState('walk', {direction = 'right'})
    elseif love.keyboard.isDown('up','w') then
        self.party:changeState('walk', {direction = 'up'})
    elseif love.keyboard.isDown('down','s') then
        self.party:changeState('walk', {direction = 'down'})
    end
end