--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Alejandro Mujica
    aledrums@gmail.com

    This class contains the class TakeTurnState.
]]
TakeTurnState = Class{__includes = BaseState}

function TakeTurnState:init(battleState)
    self.battleState = battleState
    self.party = battleState.party
    self.characters = self.party.characters
    self.enemies = battleState.enemies
    self.enemyAttacksInARow = 0
    self.entities_in_game = {}
end

function TakeTurnState:update(dt)
    self.battleState:update(dt)
end

function TakeTurnState:enter(params)
    self:everyone_cooldown()
end

function TakeTurnState:everyone_cooldown()

    local k = 1
    while (k < 6) do
        if k < 5 then
            if (self.characters[k].currentRest >= self.characters[k].restTime) and not self.characters[k].dead then
                self:takePartyTurn(k)
                return
            end
        end
        if k <= #self.enemies then
            if (self.enemies[k].currentRest >= self.enemies[k].restTime) and not self.enemies[k].dead  then
                self:takeEnemyTurn(k)
                return
            end
        end
        k = k + 1
    end

    stateStack:push(BattleMessageState(self.battleState,'Charging Energy Bars...',
    function()
        stateStack:pop() 
        Timer.after(1, function () 
        stateStack:push(TakeTurnState(self.battleState))
        end) 
    end,false,true ))
end

function TakeTurnState:takePartyTurn(i)

        local c = self.characters[i]
            stateStack:push(BattleMessageState(self.battleState, 'Turn for ' .. c.name .. '! Select an action.',
            -- callback for when the battle message is closed
            function()
                stateStack:push(SelectActionState(self.battleState, c,

                -- callback for when the action has been selected
                function()
                    if self:checkAllDeath(self.enemies) then
                        self:victory()
                        else
                            self:everyone_cooldown()
                        end
                    end))
                end))
    end
-- end

function TakeTurnState:takeEnemyTurn(i)

    local e = self.enemies[i]


        self.enemyAttacksInARow = self.enemyAttacksInARow + 1
         
        local message = ''

        -- choose a randoms action
        local action = e.actions[math.random(#e.actions)]
        e.currentRest = 0
        Timer.tween(0.2, {
            [self.battleState.restBars[e.name]] = {value = e.currentRest}
        })

        local targets = action.target_type == 'enemy' and self.characters or self.enemies

        if action.require_target then
            local target_p = math.random(#targets)
            
            while targets[target_p].dead do
                target_p = math.random(#targets)
            end
            
            local target = targets[target_p]
            
            local amount = action.func(e, target)
            
            SOUNDS[action.sound_effect]:stop()
            SOUNDS[action.sound_effect]:play()
            
            Timer.tween(0.5, {
                [self.battleState.energyBars[target.name]] = {value = target.currentHP}
            })

            message = e.name .. ' used ' .. action.name .. ' for '.. amount .. ' HP on ' .. target.name .. '.'
        else
            local amount = action.func(e, targets)

            SOUNDS[action.sound_effect]:stop()
            SOUNDS[action.sound_effect]:play()

            local targetName = action.target_type == 'enemy' and 'you' or 'them'

            message = e.name .. ' used ' .. action.name .. ' for ' .. amount .. ' HP on all of ' .. targetName .. '.'
        end

        local gameOver = self:checkAllDeath(self.characters)
        
        if gameOver then
            self:faint()
        else
            stateStack:push(BattleMessageState(self.battleState, message,
                -- callback for when the battle message is closed
                function()
                    -- chance to attack again
                    if self.enemyAttacksInARow < 3 and e.type == 'boss' and math.random(3) == 1 then
                        self:takeEnemyTurn(i)
                    else
                        self.enemyAttacksInARow = 0
                        self:everyone_cooldown()
                    end
                end))
        end
end

function TakeTurnState:checkAllDeath(team)
    for k, e in pairs(team) do
        if not e.dead then
            return false
        end
    end
    return true
end

function TakeTurnState:faint()
    SOUNDS['battle']:stop()
    SOUNDS['game-over']:play()
    stateStack:push(FadeInState({
        r = 0, g = 0, b = 0
    }, 1,
    function()
        stateStack:push(GameOverState())
    end))
end

function TakeTurnState:incExp(i, opponentLevel)
    if i > #self.characters then
        self:fadeOut()
        return
    end

    local c = self.characters[i]

    if c.dead then
        self:incExp(i + 1, opponentLevel)
    else
        local exp = math.ceil((c.HPIV + c.attackIV + c.defenseIV + c.magicIV) * opponentLevel)

        stateStack:push(BattleMessageState(self.battleState, c.name .. ' earned ' .. tostring(exp) .. ' experience points!',
        function() end,false))

        Timer.after(1.5, function()
            SOUNDS['exp']:play()

            -- animate the exp filling up
            Timer.tween(0.5, {
                [self.battleState.expBars[c.name]] = {value = math.min(c.currentExp + exp, c.expToLevel)}
            })
            :finish(function()
                
                -- pop exp message off
                stateStack:pop()

                c.currentExp = c.currentExp + exp

                -- level up if we've gone over the needed amount
                if c.currentExp >= c.expToLevel then
                    
                    SOUNDS['levelup']:play()

                    -- set our exp to whatever the overlap is
                    c.currentExp = c.currentExp - c.expToLevel

                    local lastLevel = c.level
                    local HPIncrease, restDecrease, attackIncrease, defenseIncrease, magicIncrease = c:levelUp()

                    Timer.tween(0.5, {
                        [self.battleState.energyBars[c.name]] = {value = c.currentHP - HPIncrease}
                    })

                    stateStack:push(BattleMessageState(self.battleState, 'Congratulations! ' .. c.name ..
                                                        ' advanced from level ' .. lastLevel .. ' level ' .. c.level .. '!',
                    function()
                        stateStack:push(StatsMenuState(c,
                            {
                                HPIncrease = HPIncrease,
                                restDecrease = restDecrease,
                                attackIncrease = attackIncrease,
                                defenseIncrease = defenseIncrease,
                                magicIncrease = magicIncrease
                            },
                            function()
                                self:incExp(i + 1, opponentLevel)
                            end))
                    end))
                else
                    self:incExp(i + 1, opponentLevel)
                end
            end)
        end)

    end
end

function TakeTurnState:victory()

    for k, c in pairs(self.party.characters) do
        if not c.dead then
            c.currentRest = 0
        else
            c.currentHP = 0
        end
    end  

    -- play victory music
    SOUNDS['battle']:stop()

    SOUNDS['victory']:setLooping(true)
    SOUNDS['victory']:play()

    -- when finished, push a victory message
    stateStack:push(BattleMessageState(self.battleState, 'Victory!',
        function()
            local opponentLevel = 0

            for k, e in pairs(self.enemies) do
                opponentLevel = opponentLevel + e.level
            end
            self:incExp(1, opponentLevel/#self.characters)
        end))
    
end

function TakeTurnState:fadeOut()
    if self.battleState.finalBoss then
        SOUNDS['victory']:stop()

        stateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 3, 
        function()
            SOUNDS['the-end']:play()

            stateStack:push(TheEndState())

            stateStack:push(FadeOutState({
                r = 0, g = 0, b = 0
            }, 1, 
            function() end))
        end))
    else
        -- fade in
        stateStack:push(FadeInState({
            r = 255, g = 255, b = 255
        }, 1, 
        function()

            -- resume field music
            SOUNDS['victory']:stop()
            SOUNDS['world']:play()

            stateStack:pop()
            
            -- pop off the battle state
            stateStack:pop()
            
            stateStack:push(FadeOutState({
                r = 255, g = 255, b = 255
            }, 1, function() end))
        end))
    end
end