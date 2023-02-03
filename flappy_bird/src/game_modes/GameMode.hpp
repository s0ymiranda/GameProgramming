
#pragma once

#include <SFML/Window/Event.hpp>
#include <Settings.hpp>
#include <src/Bird.hpp>

#include <memory>

//#include <SFML/Graphics.hpp>

class Bird;
class LogPair;

class GameMode 
{

public:

    virtual void set_generate_log_hard() noexcept {};
    
    virtual float get_logs_gap() noexcept = 0 ;

    virtual float get_time_for_next_log_pair() noexcept = 0;
 
    virtual void handle_inputs(const sf::Event& event) noexcept {};

    virtual void update(float dt, std::shared_ptr<Bird> bird) noexcept {};

    //virtual int get_generate_log_hard() noexcept = 0;
    //virtual void update_logs(float dt, float *vy, float *y, std::shared_ptr<LogPair> log_pair) noexcept {};
    virtual void update_logs(float dt, float *vy, float *y, bool *closing) noexcept {};


    virtual void reset() noexcept {};

};