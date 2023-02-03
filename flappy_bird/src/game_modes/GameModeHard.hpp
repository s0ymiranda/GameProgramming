#pragma once

#include <random>
#include <src/game_modes/GameMode.hpp>
#include <Settings.hpp>
#include <src/Bird.hpp>
#include <src/LogPair.hpp>

class GameModeHard: public GameMode 
{
public: 
    float get_logs_gap() noexcept override;

    float get_time_for_next_log_pair() noexcept override;

    void handle_inputs(const sf::Event& event) noexcept override;

    void update(float dt, std::shared_ptr<Bird> bird = nullptr) noexcept override;

    //void set_generate_log_hard() noexcept override;

    //int get_generate_log_hard() noexcept override;

//    void update_logs(float dt, float *vy, float *y, std::shared_ptr<LogPair> log_pair = nullptr) noexcept override;

    void update_logs(float dt, float *vy, float *y, bool *closing) noexcept override;


    void reset() noexcept override;
private:

    bool bird_moving_right = false;
    bool bird_moving_left = false;
    std::mt19937 rng;
    int generate_log_hard = false;

};