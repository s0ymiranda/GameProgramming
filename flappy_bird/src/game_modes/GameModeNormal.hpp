#pragma once

#include <random>
#include <src/game_modes/GameMode.hpp>
#include <Settings.hpp>

class GameModeNormal: public GameMode 
{
    
public: 

    float get_logs_y() noexcept override;

    float get_time_for_next_log_pair() noexcept override;

    bool generate_powerups() noexcept override;

    bool ghost_bird_colission() noexcept override;

    void handle_inputs(const sf::Event& event) noexcept override;

    void update(float dt, std::shared_ptr<Bird> bird = nullptr) noexcept override;

    void powerup_collides(std::shared_ptr<Bird> bird, std::shared_ptr<World> world) noexcept override;

    void update_logs(float dt, float *vy, float *y, bool *closing, int move) noexcept override;

    void reset() noexcept override;

    void change_bird_texture(std::shared_ptr<Bird> bird) noexcept override;

private:

    std::mt19937 rng{std::default_random_engine{}()};
    std::uniform_int_distribution<int> dist{0, 80};
    float last_log_y = -Settings::LOG_HEIGHT + dist(rng) + 20;

};