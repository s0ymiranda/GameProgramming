--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    This class contains the class BaseMessageState.
]]
BattleMessageState = Class{__includes = BaseState}

function BattleMessageState:init(battleState, msg, onClose, canInput, onBattle)
    self.battleState = battleState
    self.textbox = Textbox(0, VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH, 64, msg, FONTS['medium'])

    -- function to be called once this message is popped
    self.onClose = onClose or function() end
    self.onBattle = onBattle
    -- whether we can detect input with this or not; true by default
    self.canInput = canInput

    -- default input to true if nothing was passed in
    if self.canInput == nill then self.canInput = true end
    if self.onBattle == nill then self.onBattle = true end
end

function BattleMessageState:update(dt)
    if self.onBattle then 
        self.battleState:update(dt)
    end
    if self.canInput then
        self.textbox:update(dt)
        if self.textbox:isClosed()then
            stateStack:pop()
            self.onClose()
        end
    end
    if not self.canInput and self.battleState:restDone() and self.onBattle then
        stateStack:pop()
        self.onClose()
    end
end

function BattleMessageState:render()
    self.textbox:render()
end