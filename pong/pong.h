/*
    ISPPJ1 2023
    Study Case: Pong

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of a pong game and the declaration
    of the functions to init it, update it, and render it.
*/

#include "paddle.h"
#include "ball.h"
#include "sounds.h"

/* 

    EDITS: 
    we created two new states, and no longer have the "PLAY" state.
    "PLAYMULTI" is for the option Multiplayer and this state managed the original code (human vs human)
    "PLAYSINGLE" is for the option Singleplayer and this state managed our code addings (human vs Ia)

*/

enum PongState
{
    START,
    SERVE,
    PLAYMULTI, 
    PLAYSINGLE,
    DONE
};

struct Pong
{
    struct Paddle player1;
    struct Paddle player2;
    struct Ball ball;

    enum PongState state;

    int player1_score;
    int player2_score;
    int serving_player;
    int winning_player;
    int game_option;

    struct Sounds* sounds;
};

void init_pong(struct Pong* pong, struct Sounds* sounds);

void handle_input_pong(struct Pong* pong, ALLEGRO_KEYBOARD_STATE* state);

void update_pong(struct Pong* pong, double dt);

void render_pong(struct Pong pong, struct Fonts fonts);
