--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Alejandro Mujica
    aledrums@gmail.com

    This class contains the class CharacterMenuState.
]]
CharacterMenuState = Class{__includes = BaseState}

function CharacterMenuState:init(party,character,onClose)
    self.character = character
    self.party = party
    -- self.HPIncrease = stats.HPIncrease
    -- self.attackIncrease = stats.attackIncrease
    -- self.defenseIncrease = stats.defenseIncrease
    -- self.magicIncrease = stats.magicIncrease

    -- self.previousHP = self.character.HP - self.HPIncrease
    -- self.previousAttack = self.character.attack - self.attackIncrease
    -- self.previousDefense = self.character.defense - self.defenseIncrease
    -- self.previousMagic = self.character.magic - self.magicIncrease

    self.onClose = onClose or function() end
    
    local livingState
    if character.dead then
        livingState = 'Dead'
    else 
        livingState = "Alive"
    end

    local workingShowCursor
    local workingAlpha

    if self.character.class == 'healer' then
        workingAlpha = 255
        workingShowCursor = true
    else
        workingAlpha = 50
        workingShowCursor = false
    end

    self.on_render = true

    if #self.character.actions > 1 then
        self.actionsMenu = Menu {
            alpha = workingAlpha,
            x = 48 + 160,
            y = 48,
            width = 64,
            height = 48,
            showCursor = workingShowCursor,
            font = FONTS['small'],  
            items = {
                {
                    text =  self.character.actions[1].name,
                    onSelect = function()
                        if self.character.class == 'healer' and not self.character.dead then
                            self.on_render = false
                            stateStack:push(SelectPartyMemberState(self.party,
                                function(selectedTarget)
                                    local amount = self.character.actions[1].func(self.character,selectedTarget,self.character.actions[1].strength)
                                    SOUNDS[self.character.actions[1].sound_effect]:play()
                                    stateStack:push(DialogueState(self.character.name .. ' healed ' .. amount .. ' of HP to ' .. selectedTarget.name,self:close()))
                                end
                                )
                            )
                        else
                            self:close()
                        end
                    end
                },
                {
                    text =  self.character.actions[2].name,
                    onSelect = function()
                        if self.character.class == 'healer' and not self.character.dead  then
                            local amount = self.character.actions[2].func(self.character,self.party.characters,self.character.actions[2].strength)
                            SOUNDS[self.character.actions[2].sound_effect]:play()
                            stateStack:push(DialogueState(self.character.name .. ' healed ' .. amount .. ' of HP to each party member.',self:close()))
                        else
                            self:close()
                        end
                    end
                }
            }
        }
    else
        self.actionsMenu = Menu {
            alpha = workingAlpha,      
            x = 48 + 160,
            y = 48,
            width = 64,
            height = 48,
            showCursor = workingShowCursor,
            font = FONTS['small'],  
            items = {
                {
                    text =  self.character.actions[1].name,
                    onSelect = function()
                        self:close()
                    end
                }
            }
        }
    end

    self.statsMenu = Menu {
        x = 48,
        y = 48,
        width = 128,
        height = 128,
        showCursor = false,
        font = FONTS['small'],
        items = {
            {
                text = 'Name: ' .. self.character.name .. ' - ' .. livingState,
                onSelect = function()
                    self:close()
                end
            },
            {
                text = 'Level: ' .. self.character.level,
                onSelect = function()
                    self:close()
                end
            },
            {
                text = 'EXP: ' .. self.character.currentExp .. ' / ' .. self.character.expToLevel,
                onSelect = function()
                    self:close()
                end
            },
            {
                text = 'HP: '.. self.character.currentHP .. ' / ' .. self.character.HP,
                onSelect = function()
                    self:close()
                end
            },
            {
                text = 'Attack: ' ..self.character.attack,
                onSelect = function()
                    self:close()
                end
            },
            {
                text = 'Defense: ' .. self.character.defense,
                onSelect = function()
                    self:close()
                end
            },
            {
                text = 'Magic: ' .. self.character.magic,
                onSelect = function()
                    self:close()
                end
            }
        }
    }
end

function CharacterMenuState:close()
    stateStack:pop()
    self.onClose()
end

function CharacterMenuState:update(dt)
    --self.statsMenu:update(dt)
    self.actionsMenu:update(dt)
end

function CharacterMenuState:render()
    if self.on_render then
        self.statsMenu:render()
        self.actionsMenu:render()
    end
end