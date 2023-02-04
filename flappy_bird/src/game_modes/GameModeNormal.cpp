#include <src/game_modes/GameModeNormal.hpp>
#include <Settings.hpp>

float GameModeNormal::get_logs_gap() noexcept
{
    return Settings::LOGS_GAP;
}

float GameModeNormal::get_time_for_next_log_pair() noexcept
{
    return Settings::TIME_TO_SPAWN_LOGS;
}

void GameModeNormal::handle_inputs(const sf::Event &event) noexcept
{

}


void GameModeNormal::update(float dt, std::shared_ptr<Bird> bird) noexcept
{

}

void GameModeNormal::update_logs(float dt, float*vy, float* y, bool* closing, int move) noexcept
{

    *vy = 0;

}

void GameModeNormal::reset() noexcept
{
   
}