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

void GameModeHard::handle_inputs(const sf::Event &event) noexcept
{

    if(sf::Keyboard::isKeyPressed(sf::Keyboard::A))
    {
        bird_moving_left = true;
        bird_moving_right = false;
    }
    else if(sf::Keyboard::isKeyPressed(sf::Keyboard::D))
    {
        bird_moving_right = true;
        bird_moving_left = false;
    }
    else
    {
        bird_moving_right = false;
        bird_moving_left = false;
    }
}


void GameModeHard::update(float dt, std::shared_ptr<Bird> bird) noexcept
{
    if (bird_moving_right)
    {
        bird->move_on_x(80*dt);
    }
    else if(bird_moving_left)
    {
        bird->move_on_x(-80*dt);
    }
}

void GameModeHard::update_logs(float dt, float*vy, float* y, bool* closing, int move) noexcept
{

    if(move == 2)
    {
        if(*y + Settings::LOG_HEIGHT + *vy <= *y + Settings::LOG_HEIGHT + Settings::LOGS_GAP/2 && *closing)
        {
            *vy += dt*20;
        }
        else if(*y + Settings::LOG_HEIGHT + *vy >= *y + Settings::LOG_HEIGHT)
        {
            if(*closing)
            {
                Settings::sounds["logs_crash"].play();
            }
            *closing = false;
            *vy += -dt*20;
        }
        else
        {
            *closing = true;
        }
    }

}

void GameModeHard::reset() noexcept
{
    bird_moving_right = false;
    bird_moving_left = false;      
}