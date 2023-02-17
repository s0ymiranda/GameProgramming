New Features

    Our states receives the pointers/values of the World, Bird, GameMode and Score.
    
    Pause Screen State: Located in the folder states, this state allows the user to pause de game, in here it can either resume the game or go the Menu State.

    Menu State: Located in the folder states, this state allows the user to pick between "Normal" or "Hard" Game Mode.

    There were added new sounds and music to the game, these new sounds can be found in the "sounds" folder. this new sounds are for the music that is play when the bird collides with a PowerUp, and the other sound is for when the logs collided while closing.

    Folder game_modes: in here we can find the following archives
                        -GameMode.hpp
                        -GameModeHard.cpp
                        -GameModeHard.hpp
                        -GameModeNormal.cpp
                        -GameModeNormal.hpp

                        through this new classes we implement the Strategy pattern Design which allows us to have different logics/actions depending on the Game Mode selected by the user.

    LogPair: The way that was implemented the logs' closing and opening movement was implementing a velocity to the actualization of the position on each log in the log_pair class (top log and bottom log). In GameModeHard and GameModeNormal it can be found the method update_logs, this method is called in the update of the LogPair class, that, depending on the current game mode acts differently (for example if it is hard we give the logs a velocity in Y). The way the factory creates the new logs for the GameModeHard is receiving two more params, the game_mode and a random number, with these params it is determined if a log with movement is spawn.

    Added a new class called "PowerUp", its texture can be found in the graphics folder. 
    
    In the "World" class it can be found the logic for generate the PowerUps in the world (this only will happen if the current Game Mode its hard), that works very similar to the logic for generate logs, in here is added ass well a new method to validate if there is any colission whit the powerups render in the world, in here as well we get some values from the game_mode (for example the time for generate a new log).

    In the "Bird" class it is added a new method to get the sprite that is currenty in use, this is because in Game Mode Hard if the bird collide whit a powerUp it should change its texture, this new texture can be found in the graphics folder, now the bird can't go up until the limits of the window, as wel no either the left part of the window.
    
    In the state PlayingState there is some call to the game_mode, that reacts different depending on the current Game Mode, for example in the method Update there is a call to update from the game_mode, in Hard Mode this update several things (like the movement of the bird to the right or left), in Normal Mode it does not do anything new.

    








    
