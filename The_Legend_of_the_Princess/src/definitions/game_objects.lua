--[[
    ISPPJ1 2023
    Study Case: The Legend of the Princess (ARPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by Alejandro Mujica (alejandro.j.mujic4@gmail.com) for teaching purpose.

    This file contains the definition for game objects.
]]
GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['chest'] = {
        type = 'chest',
        texture = 'chest2',
        frame = 2,
        width = 32,
        height = 32,
        solid = true,
        defaultState = 'closed',
        states = {
            ['closed'] = {
                frame = 1
            },
            ['open'] = {
                frame = 2
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 16,
        width = 16,
        height = 16,
        solid = true,
        consumable = false,
        defaultState = 'default',
        takeable = true,
        states = {
            ['default'] = {
                frame = 16
            }
        }
    },
    -- definition of heart as a consumable object type
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        consumable = true,
        defaultState = 'default',
        states = {
            ['default'] = {
                frame = 5
            }
        },
        onConsume = function(player)
            player:heal(2)
            SOUNDS['heart-taken']:play()
        end
    }

    --own try
    ,
    ['bow'] = {
        type = 'bow',
        texture = 'rotbow',
        frame = 16,
        width = 20,
        height = 20,
        solid = false,
        consumable = true,
        defaultState = 'default',
        takeable = true,
        states = {
            ['default'] = {
                frame = 5
            },
            ['left'] = {
                frame = 11
            },
            ['right'] = {
                frame = 3
            },
            ['down'] = {
                frame = 15
            },
            ['up'] = {
                frame = 7
            },
            ['throw-left'] = {
                frame = 13
            },
            ['throw-right'] = {
                frame = 16
            },
            ['throw-down'] = {
                frame = 14
            },
            ['throw-up'] = {
                frame = 12
            }
        },
        onConsume = function(player)
            --player:heal(2)
            player:take_bow()
            SOUNDS['heart-taken']:play()
        end
    },
    ['Fireball'] = {
        type = 'fireball',
        texture = 'fireball',
        frame = 7,
        width = 15,
        height = 15,
        solid = true,
        defaultState = 'handAnim',
        states = {
            ['handAnim'] = {
                frame = 1
            },
            ['handAnim2'] = {
                frame = 2
            },
            ['handAnim3'] = {
                frame = 3
            },
            ['shoot1'] = {
                frame = 4
            },
            ['shoot2'] = {
                frame = 5
            },
            ['shoot3'] = {
                frame = 6
            }           
        }
    },
    

}

