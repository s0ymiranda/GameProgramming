
#pragma once

#include <SFML/Window/Event.hpp>
#include <Settings.hpp>
#include <src/Bird.hpp>

#include <memory>

//#include <SFML/Graphics.hpp>

class Bird;

class GameMode 
{

public:

    virtual float get_logs_gap() noexcept = 0 ;

    virtual float get_time_for_next_log_pair() noexcept = 0;
 
    virtual void handle_inputs(const sf::Event& event) noexcept {};

    virtual void update(float dt, std::shared_ptr<Bird> bird) noexcept {};

    virtual void reset() noexcept {};

};