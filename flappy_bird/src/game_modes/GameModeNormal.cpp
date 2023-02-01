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