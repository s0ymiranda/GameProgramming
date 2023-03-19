New Features

    graphics: replace old version of tileset, now it have the old tiles plus neww tiles that are the textures for the level 2.

    definitions: AAdded the new definitions for the new tiles and the item key.

    tilemaps: Added level2.tmx which have the information for loading the level 2.

    BeginGameState: Added a new game state called "BeginGameState" this is just for execute a transitions between levels, it receives the level and player. After the transitions are done, changes the state to PlayState and send the level plus 1 (this is for going to the next level) and send the player (this is done for keeping info about the colected coins and score between levels).

    StartState: Now instead of going derectly to PlayState after pressing "enter", it goes to BeginGameState. 

    PlayState: now if the player reach a 100 score and it is on the level 1, it will show a new bloque, when he collides whit it, it will spawn a key, when he takes it change the state to BeginGameState and go to the level 2.