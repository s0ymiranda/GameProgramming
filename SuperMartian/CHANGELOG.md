New Features

    graphics: replace old version of tileset, now it have the old tiles plus neww tiles that are the textures for the level 2.

    definitions: Added the new definitions for the new tiles and the item key.
                 Items:
                    Added the new item "next_level", this new item is the key that allows the player to change to the next level.
                    Added the methods spawn_key [it makes the kay visible], make_consumable [it make an item consumable], go_to_next_level [it allows the player to go to the next level]

    tilemaps: Added level2.tmx which have the information for loading the level 2.

    BeginGameState: Added a new game state called "BeginGameState" this is just for execute a transitions between levels, it receives the level and player. After the transitions are done, changes the state to PlayState and send the level plus 1 (this is for going to the next level) and send the player (this is done for keeping info about the colected coins and score between levels).

    StartState and GameOverState: Now instead of going derectly to PlayState after pressing "enter", it goes to BeginGameState. 

    PlayState: now if the player reach a 250 score and it is on the level 1, it will stop the timer, play a new background music, play a sound that indicates to the player that something has happend and it will show a new bloque, when he collides whit the bottom of the block, it will spawn a key, when he takes the key, the game will change the state to BeginGameState and go to the level 2.

    TmxLevelLoader: now it can read multiple layers of items.

    GameItem: Added the property visible, that allows the item to be visible or not.

    GameObject: Added the property in_play, that tells if the object is currently in the game or not

    GameLevel: when it loads the "next_level" [the key] item it makes that item not in play and not visible

    Tilemap: when it loads the tile that is the block that contains the key, there it will be turned not in play