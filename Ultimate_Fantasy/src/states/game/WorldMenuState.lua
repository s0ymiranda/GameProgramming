--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by: Alejandro Mujica (alejandro.j.mujic4@gmail.com)

    This class contains the class WorldMenuState.
]]
WorldMenuState = Class{__includes = BaseState}

function WorldMenuState:init(party,last_selection)

    self.party = party
    self.last_selection = last_selection or 1
    self.charactersMenu = Menu {
        x = VIRTUAL_WIDTH/2 - 128/2,
        y = VIRTUAL_HEIGHT/2 - 160/2,
        width = 128,
        height = 160,
        current_selection = last_selection,
        items = {
            {
                text = party.characters[1].name,
                onSelect = function()
                    stateStack:pop()
                    stateStack:push(CharacterMenuState(self.party,self.party.characters[1],1))
                end
            },
            {
                text = party.characters[2].name,
                onSelect = function()
                    stateStack:pop()
                    stateStack:push(CharacterMenuState(self.party,self.party.characters[2],2))
                end
            },
            {
                text = party.characters[3].name,
                onSelect = function()
                    stateStack:pop()
                    stateStack:push(CharacterMenuState(self.party,self.party.characters[3],3))
                end
            },
            {
                text = party.characters[4].name,
                onSelect = function()
                    stateStack:pop()
                    stateStack:push(CharacterMenuState(self.party,self.party.characters[4],4))
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
    self.charactersMenu:update(dt)
end

function WorldMenuState:render()
     self.charactersMenu:render()
end