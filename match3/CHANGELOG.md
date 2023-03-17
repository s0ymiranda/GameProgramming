New Features 
Tile.py
    Added the property can_match to the tiles.

    The tile that have variety 7 it means that it is a croos powerUp, it have its proper texture.

    The tile that have variety 8 it means that it is a color powerUp, it have its proper texture.


Board.py 
    Function RecreateBoard: This functions calls the initialize_tiles function

    Function cross_power_up: This function works for when a cross power up its activated it will remove from the board the proper tiles.

    Function color_power_up: This function works for when a color power up its activated it will remove from the board the proper tiles, Also it will return the quantity of how many tiles of the same color were removed, this is for calculating the score

    Function WillThereBeAMatch: This function will check a tile, if anywhere its moved can do a match, it will add the property can_match = True to the tiles that can do. 

    Funtion CanMove: This Function checks if the tile can move, this is for them not to be able to exceed the limits of the board.

    Funtion ExistMatch: This function will check the board for posibles matchs.

    Function swap_tiles: This Function swap the position of two tiles.

PlayState.py
    On Update function, it is use the ExistMatch and the recreateBorad  functions from the board, they are used for if there is no matches in the board, it will recreate the board.

    On render function, it is implemented a helper, after 20 seconds if the user havent done anything it will highlight the tiles that have the property can-match on true.

    On on_input function

        the input_id click and data pressed
            in here on_motion = true, this is for have the information about if there is a click and the user havent released yet 
            its selected the tile 1 as in the previous version, now there is not a higlighted tile.

        now there is the input_ids:  "motion_rigth", "motion_left", "motion_up", "motion_down" they are added in conditions whit self.on_motion, this is for is the user havent release the click and check whiich direction it is moving.

        The input_id click and data released
            if the user released the click it means that he exchange the tiles or wheter he activated a powerUp.
    
    Funtion cross_power_up: in here its called the cross_power_up function of the board, the score that this powerup gives is 15*25, as you can see each tile gives 25 points, we nerfed the 50 that usually each tile can give, tween for the falling tiles.

    Funtion color_power_up: in here its called the color_power_up function of the board, the score that this powerup gives is quantity*50, quantity is the number of how many tiles were removed.

    On calculate_matches function, in here if we match 4 tiles, it will spawn a cross_power_up, if we match 5 or more it will spawn a color_power_up.