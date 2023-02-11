#include <src/game_modes/GameModeNormal.hpp>
#include <Settings.hpp>

float GameModeNormal::get_logs_y() noexcept
{
    std::uniform_int_distribution<int> dist{-20, 20};
    float y = std::max(-Settings::LOG_HEIGHT + 10, std::min(last_log_y + dist(rng), Settings::VIRTUAL_HEIGHT + 90 - Settings::LOG_HEIGHT));
    last_log_y = y;
    return y;
}

float GameModeNormal::get_time_for_next_log_pair() noexcept
{
    return Settings::TIME_TO_SPAWN_LOGS;
}

bool GameModeNormal::generate_powerups() noexcept
{
   return false;
}

bool GameModeNormal::ghost_bird_colission() noexcept
{
    return false;
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
void GameModeNormal::change_bird_texture(std::shared_ptr<Bird> bird) noexcept
{

}