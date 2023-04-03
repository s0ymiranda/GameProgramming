--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by: Alejandro Mujica (alejandro.j.mujic4@gmail.com)

    This class contains the class WorldMenuState.
]]
WorldMenuState = Class{__includes = BaseState}

function WorldMenuState:init(party)
    -- self.battleState = battleState
    self.party = party
    self.on_render = true
    self.charactersMenu = Menu {
        x = VIRTUAL_WIDTH/2 - 128/2,
        y = VIRTUAL_HEIGHT/2 - 160/2,
        width = 128,
        height = 160,
        items = {
            {
                text = party.characters[1].name,
                onSelect = function()
                    --stateStack:pop()
                    self.on_render = false
                    stateStack:push(CharacterMenuState(self.party,self.party.characters[1],function() self.on_render = true end))
                end
            },
            {
                text = party.characters[2].name,
                onSelect = function()
                    self.on_render = false
                    stateStack:push(CharacterMenuState(self.party,self.party.characters[2],function() self.on_render = true end))
                end
            },
            {
                text = party.characters[3].name,
                onSelect = function()
                    self.on_render = false
                    stateStack:push(CharacterMenuState(self.party,self.party.characters[3],function() self.on_render = true end))
                end
            },
            {
                text = party.characters[4].name,
                onSelect = function()
                    self.on_render = false
                    stateStack:push(CharacterMenuState(self.party,self.party.characters[4],function() self.on_render = true end))
                end
            },
            {
                text = 'Close Menu',
                onSelect = function()
                    stateStack:pop()
                end
            }
        }
    }
end

function WorldMenuState:update(dt)
    -- for k, e in pairs(self.battleState.enemies) do
    --     e:update(dt)
    -- end
    self.charactersMenu:update(dt)
end

function WorldMenuState:render()
    if self.on_render then
        self.charactersMenu:render()
    end
end