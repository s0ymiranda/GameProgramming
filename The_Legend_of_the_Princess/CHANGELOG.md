New Features

    - Added in the graphics folder the new textures for the chest ( chest2.png), bow ( rotbow_w_string.png), arrow ( arrow1.png, arrow2.png), fire ball ( FireBall.png) and the boss ( skeleton_boss.png)

    - Added in the sounds folder the new sounds for the boss room, scream for the boss, flame for the fireballs that the boss creates.

    - In src/definitions/entity.lua it can be found the proper defitions for the Boss

    - In src/definitions/game_objects.lua it can be found the proper definitions for the bow(this have the function OnConsume that set the player.have_bow in true), the arrow, the chest and the fire ball.

    - In src/world/Room.lua it can be found the implementation of how its added the chest to the game, when the player collides whit the chest from the front, it will drop the game object bow, for the player to take it, after the player takes it, it will not generate more chests.

    - Added a new archive src/world/Boss_Room.lua works similar to Room.lua, in here there will not be any objects, and the only entity is the boss, besides the player (there is a list of entities because, the player swing sword expects a list for cheking the colisions), and depends in which direction the player is looking when he enters this room, there is where the door is gonna be generated.
    
    - Added a new archive sr/FireBallProjectile.lua that uses __includes Projectile.lua this is for the variations of how the projectile that the boss shoot works, he receives and object and a target, this object its gonna be 'shoot' where the target it found at that moment that is called.

    - Added a new archive src/Boss.lua that uses __includes Entity.lua Adding the goVulnerable method and a few changes in the update.

    - Added a new archive src/states/entity/playes/PlayerShootArrowState.lua in here we created a bow for positioning whit the player and as well have the direction where the arrow should be shooted (the arrow its shoot as a projectile), we give the bow a charging time, this on purpose for adding a little more dificult than just shooting infinite arrows.

    - Added a new folder src/states/entity/boss 
        in here can be found the new archives 
        -src/states/entity/boss/BossIdleState.lua : In here it can be found the chances to go 'shoot' (to shoot a fireball)
        -src/states/entity/boss/BossShootFireballState.lua : In here we create the fireball, give the ilusion that this fireball grow, and send it to the projectiles list of the room and shoots it as a projectile (using FireBallProjectile)
        -src/states/entity/boss/BossWalkStateState.lua : In here It can be found the chances to go to 'idle' or 'shoot'

    -In sr/world/Dungeon.lua can be found the condition for when the NextRoom its gonna be a Boss_Room

    EXTRA: -When the boss is at the 30% of his life, it's played the sound boss scream, his WalkSpeed its aumented and the chances to shoot fireballs are incremented.
           -The player can move whit the keys 'a', 'w', 's', 'd'. 


