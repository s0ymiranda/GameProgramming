/*
    ISPPJ1 2023
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the declaration of the class LogPair.
*/

#pragma once

#include <src/Bird.hpp>
#include <src/Log.hpp>
#include <src/game_modes/GameMode.hpp>

class LogPair
{
public:
    LogPair(float _x, float _y, std::shared_ptr<GameMode> _game_mode = nullptr, int _move = 0) noexcept;

    bool collides(const sf::FloatRect& rect) const noexcept;

    void update(float dt) noexcept;

    void render(sf::RenderTarget& target) const noexcept;

    bool is_out_of_game() const noexcept;

    bool update_scored(const sf::FloatRect& rect) noexcept;

    void reset(float _x, float _y) noexcept;

    void change_move_status() noexcept;

private:
    float x;
    float y;
    Log top;
    Log bottom;

    bool scored{false};

    std::shared_ptr<GameMode> game_mode;

    //hard mode
    float vy;
    bool closing;
    int move;
};