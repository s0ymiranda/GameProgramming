New Features

    main.c.84      - New condition for updating the inputs give by the IA.

    pong.h.30-31   - Changed the state "PLAY" into "PLAYSINGLE" and "PLAYMULTI".

    pong.h.46      - Added the variable "game_option" for the options multiplayer "1" and singleplayer "2".

    pong.c.30      - Added "pong->game_option = 0"

    pong.c37-52    - Changed the way that "pong->state == START" works, "game_option = 1" if ALLEGRO_KEY_1 or "game_option = 2" if ALLEGRO_KEY_2

    pong.c.57-64   - Here is where it is changed the pong->state to "MULTIPLAYER" or "SINGLEPLAYER"

    pong.c.76      - Changed the condition "pong->state == PLAY" to "pong->state == PLAYMULTI".
   
    pong.c.104     - Added the condition "pong->state == PLAYSINGLE" (here is where the IA is implemented)
                        (logic for player1 in here is the original).
                 
    pong.c.121-135 - Logic for IA implemented in player 2.
    
    pong.c.139-148 - Changed the form the game reacts when there is a winner, now, when the user press enter it change the state to "START" in consequence to the main menu.

    pong.c.175     - Changed the "serving_player" to 1.

    pong.c.192     - Changed the "serving_player" to 2.

    pong.c.256-272 - Added condition for "paint" the map unless the state is "START"

    pong.c.274-278 - Now you can choose to play single or multiplayer mode.

    pong.c.189-196 - Condition for thw winner message (CPU OR PLAYER 2)

    pong.c.292     - Changed the final message that is shown in the screen.

    Extra: Added a new font "big_font" for the title Pong.