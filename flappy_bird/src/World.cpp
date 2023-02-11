/*
    ISPPJ1 2023
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of the class World.
*/

#include <Settings.hpp>
#include <src/World.hpp>

World::World(std::shared_ptr<GameMode> _game_mode, bool _generate_logs, bool _generate_powerUps) noexcept
    : game_mode{_game_mode}, generate_logs{_generate_logs}, generate_powerUps{_generate_powerUps}, background{Settings::textures["background"]}, ground{Settings::textures["ground"]},
      logs{}, rng{std::default_random_engine{}()}
{
    ground.setPosition(0, Settings::VIRTUAL_HEIGHT - Settings::GROUND_HEIGHT);
    time_to_spawn_logs = Settings::TIME_TO_SPAWN_LOGS;
}

void World::reset(std::shared_ptr<GameMode> _game_mode, bool _generate_logs, bool _generate_powerUps) noexcept
{
    game_mode = _game_mode;
    generate_logs = _generate_logs;
    generate_powerUps = _generate_powerUps;
}

bool World::collides(const sf::FloatRect &rect) const noexcept
{
    if (game_mode->ghost_bird_colission())
    {
        return false;
    }
    if (rect.top + rect.height >= Settings::VIRTUAL_HEIGHT)
    {
        return true;
    }

    for (auto log_pair : logs)
    {
        if (log_pair->collides(rect))
        {
            return true;
        }
    }

    return false;
}
bool World::powerUp_collides(const sf::FloatRect &rect) noexcept
{

    power = false;
    for (auto it2 = powerUps.begin(); it2 != powerUps.end();)
    {
        if ((*it2)->get_collision_rect().intersects(rect))
        {
            power = true;
            auto powerup = *it2;
            powerUp_factory.remove(powerup);
            it2 = powerUps.erase(it2);
        }
        else
        {
            ++it2;
        }
    }
    if (power)
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool World::update_scored(const sf::FloatRect &rect) noexcept
{
    for (auto log_pair : logs)
    {
        if (log_pair->update_scored(rect))
        {
            return true;
        }
    }

    return false;
}

void World::update(float dt) noexcept
{
    if (generate_logs)
    {
        logs_spawn_timer += dt;

        if (logs_spawn_timer >= time_to_spawn_logs)
        {
            logs_spawn_timer = 0.f;

            float new_log_y = game_mode->get_logs_y();

            int random = rand() % 4;

            logs.push_back(log_factory.create(Settings::VIRTUAL_WIDTH, new_log_y, game_mode, random));

            time_to_spawn_logs = game_mode->get_time_for_next_log_pair();
        }
    }
    if (generate_powerUps)
    {
        powerUps_spawn_timer += dt;

        std::uniform_int_distribution<int> spawn{10, 15};
        float powerupSpawn = spawn(rng);

        if (powerUps_spawn_timer >= powerupSpawn)
        {
            powerUps_spawn_timer = 0.f;

            std::uniform_int_distribution<int> dist{50, static_cast<int>(Settings::VIRTUAL_HEIGHT - 60)};
            float y = dist(rng);

            powerUps.push_back(powerUp_factory.create(Settings::VIRTUAL_WIDTH, game_mode->get_logs_y() + Settings::LOG_HEIGHT ));
        }
    }

    background_x += -Settings::BACK_SCROLL_SPEED * dt;

    if (background_x <= -Settings::BACKGROUND_LOOPING_POINT)
    {
        background_x = 0;
    }

    background.setPosition(background_x, 0);

    ground_x += -Settings::MAIN_SCROLL_SPEED * dt;

    if (ground_x <= -Settings::VIRTUAL_WIDTH)
    {
        ground_x = 0;
    }

    ground.setPosition(ground_x, Settings::VIRTUAL_HEIGHT - Settings::GROUND_HEIGHT);

    for (auto it = logs.begin(); it != logs.end();)
    {
        if ((*it)->is_out_of_game())
        {
            auto log_pair = *it;
            log_pair->change_move_status();
            log_factory.remove(log_pair);
            it = logs.erase(it);
        }
        else
        {
            (*it)->update(dt);
            ++it;
        }
    }
    for (auto it2 = powerUps.begin(); it2 != powerUps.end();)
    {
        if ((*it2)->is_out_of_game())
        {
            auto powerup = *it2;
            powerUp_factory.remove(powerup);
            it2 = powerUps.erase(it2);
        }
        else
        {
            (*it2)->update(dt);
            ++it2;
        }
    }
}

void World::render(sf::RenderTarget &target) const noexcept
{
    target.draw(background);

    for (const auto &powerup : powerUps)
    {
        powerup->render(target);
    }
    for (const auto &log_pair : logs)
    {
        log_pair->render(target);
    }

    target.draw(ground);
}