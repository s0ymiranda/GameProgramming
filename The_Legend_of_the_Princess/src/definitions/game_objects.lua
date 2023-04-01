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
            }
        },
        onConsume = function(player)
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
            ['shoot'] = {
                frame = 7
            }        
        }
    },
    ['arrow_x'] = {
        type = 'arrow',
        texture = 'arrow_x',
        frame = 2,
        width = 17,
        height = 7,
        solid = false,
        defaultState = 'left',
        states = {
            ['left'] = {
                frame = 2
            },
            ['right'] = {
                frame = 1
            }
        }
    },
    ['arrow_y'] = {
        type = 'arrow',
        texture = 'arrow_y',
        frame = 2,
        width = 7,
        height = 17,
        solid = false,
        defaultState = 'up',
        states = {
            ['up'] = {
                frame = 1
            },
            ['down'] = {
                frame = 2
            }
        }
    }

}

