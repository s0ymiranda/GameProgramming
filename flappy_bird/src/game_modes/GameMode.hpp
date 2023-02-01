
#pragma once

#include <SFML/Window/Event.hpp>
#include <Settings.hpp>

class GameMode 
{

public:

    virtual float get_logs_gap() noexcept = 0 ;

    virtual float get_time_for_next_log_pair() noexcept = 0;

};