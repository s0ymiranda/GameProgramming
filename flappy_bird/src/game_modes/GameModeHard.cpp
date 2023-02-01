#include <src/game_modes/GameModeHard.hpp>
#include <Settings.hpp>

float GameModeHard::get_logs_gap() noexcept
{
    return Settings::LOGS_GAP;
}

float GameModeHard::get_time_for_next_log_pair() noexcept
{
    return Settings::TIME_TO_SPAWN_LOGS;
}