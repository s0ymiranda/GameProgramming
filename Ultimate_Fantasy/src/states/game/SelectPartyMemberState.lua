--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Alejandro Mujica
    aledrums@gmail.com

    This class contains the class SelectPartyMemberState.
]]
SelectPartyMemberState = Class{__includes = BaseState}

function SelectPartyMemberState:init(party, onTargetSelected)
    self.party = party
    self.targets = self.party.characters
    self.onTargetSelected = onTargetSelected or function() end
    self.currentSelection = 1
    for k, t in pairs(self.targets) do
        if t.dead then
            self.currentSelection =  self.currentSelection + 1
        else
            break
        end
    end
end

function SelectPartyMemberState:findNextAlive()
    local i = self.currentSelection < #self.targets and self.currentSelection + 1 or 1

    while self.targets[i].dead do
        i = i == #self.targets and 1 or i + 1
    end

    self.currentSelection = i
end

function SelectPartyMemberState:findPrevAlive()
    local i = self.currentSelection > 1 and self.currentSelection - 1 or #self.targets

    while self.targets[i].dead do
        i = i == 1 and #self.targets or i - 1
    end

    self.currentSelection = i
end


function SelectPartyMemberState:update(dt)
    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('d') then
        self:findNextAlive()
    elseif love.keyboard.wasPressed('left') or love.keyboard.wasPressed('a') then
        self:findPrevAlive()
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- pop this state
        stateStack:pop()
        self.onTargetSelected(self.targets[self.currentSelection])
    end
end

function SelectPartyMemberState:render()
    love.graphics.draw(TEXTURES['cursor-right'], 
    self.targets[self.currentSelection].x - TILE_SIZE, self.targets[self.currentSelection].y)
end