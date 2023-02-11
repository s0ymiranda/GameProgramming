#include <src/game_modes/GameModeHard.hpp>
#include <Settings.hpp>

float GameModeHard::get_logs_y() noexcept
{
    std::uniform_int_distribution<int> dist{-20 - int(last_generate_log_time)*12, 20 + int(last_generate_log_time)*12};
    float y = std::max( -Settings::LOG_HEIGHT + 10, std::min(last_log_y + dist(rgn), Settings::VIRTUAL_HEIGHT - Settings::LOG_HEIGHT - 100 - Settings::GROUND_HEIGHT));
    last_log_y = y;
    return y;
}

float GameModeHard::get_time_for_next_log_pair() noexcept
{
    last_generate_log_time = time_dist(rgn);
    return last_generate_log_time;
}

bool GameModeHard::generate_powerups() noexcept
{
    return true;
}

bool GameModeHard::ghost_bird_colission() noexcept
{
    return powerUp_Enable;
}

void GameModeHard::handle_inputs(const sf::Event &event) noexcept
{

    if(sf::Keyboard::isKeyPressed(sf::Keyboard::A) || sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
    {
        bird_moving_left = true;
        bird_moving_right = false;
    }
    else if(sf::Keyboard::isKeyPressed(sf::Keyboard::D) || sf::Keyboard::isKeyPressed(sf::Keyboard::Right))
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
    if (bird_moving_right )
    {
        bird->move_on_x( 80 * dt);
    }
    else if(bird_moving_left)
    {
        bird->move_on_x( -80 * dt);
    }
    if(powerUp_Enable)
    {

        timer += dt;
        if (timer >= 1.f)
        {
            timer = 0.f;
            --counter;
        }
        if (counter == 0)
        {
            bird->get_sprite()->setTexture(Settings::textures["bird"]);
            Settings::music_ghost.stop();
            Settings::music.setLoop(true);
            Settings::music.play();
            powerUp_Enable = false;
        }
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

void GameModeHard::change_bird_texture(std::shared_ptr<Bird> bird) noexcept
{
    counter = 5;
    bird->get_sprite()->setTexture(Settings::textures["ghost_bird"]);
    Settings::music.stop();
    Settings::music_ghost.setLoop(true);
    Settings::music_ghost.play();
    powerUp_Enable = true; 
}
