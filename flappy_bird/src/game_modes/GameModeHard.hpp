#pragma once

#include <random>
#include <src/game_modes/GameMode.hpp>
#include <Settings.hpp>
#include <src/Bird.hpp>
#include <src/LogPair.hpp>

class GameModeHard: public GameMode 
{
public: 
    float get_logs_y() noexcept override;

    float get_time_for_next_log_pair() noexcept override;

    bool generate_powerups() noexcept override;

    bool ghost_bird_colission() noexcept override;

    void handle_inputs(const sf::Event& event) noexcept override;

    void update(float dt, std::shared_ptr<Bird> bird = nullptr) noexcept override;

    void update_logs(float dt, float *vy, float *y, bool *closing, int move) noexcept override;

    void reset() noexcept override;

    void change_bird_texture(std::shared_ptr<Bird> bird) noexcept override;


private:

    bool bird_moving_right{false};
    bool bird_moving_left {false};
    bool powerUp_Enable{false};

    std::mt19937 rng;
    float last_generate_log_time{0.f};
    std::uniform_int_distribution<int> time_dist{int(Settings::TIME_TO_SPAWN_LOGS), int(Settings::TIME_TO_SPAWN_LOGS + 1)};

    
    float timer{0.f};
    float counter{7.f};
    
    std::mt19937 rgn{std::default_random_engine{}()};
    std::uniform_int_distribution<int> dist{0, 80};
    float last_log_y = -Settings::LOG_HEIGHT + dist(rng) + 20;

};