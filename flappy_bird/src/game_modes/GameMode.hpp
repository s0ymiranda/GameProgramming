
#pragma once

#include <SFML/Window/Event.hpp>
#include <Settings.hpp>

#include <memory>

class Bird;
class LogPair;
class World;

class GameMode 
{

public:
    
    virtual float get_logs_y() noexcept = 0 ;

    virtual float get_time_for_next_log_pair() noexcept = 0;

    virtual bool generate_powerups() noexcept = 0 ;

    virtual bool ghost_bird_colission() noexcept = 0 ;
 
    virtual void handle_inputs(const sf::Event& event) noexcept {};

    virtual void update(float dt, std::shared_ptr<Bird> bird) noexcept {};

    virtual void powerup_collides(std::shared_ptr<Bird> bird, std::shared_ptr<World> world) noexcept {};

    virtual void update_logs(float dt, float *vy, float *y, bool *closing, int move) noexcept {};

    virtual void reset() noexcept {};

    virtual void change_bird_texture(std::shared_ptr<Bird> bird) noexcept {}

};