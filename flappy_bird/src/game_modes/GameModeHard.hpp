#pragma once

#include <random>
#include <src/game_modes/GameMode.hpp>
#include <Settings.hpp>

class GameModeHard: public GameMode 
{
public: 
    float get_logs_gap() noexcept override;

    float get_time_for_next_log_pair() noexcept override;

};