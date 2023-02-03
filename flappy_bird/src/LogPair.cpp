/*
    ISPPJ1 2023
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of the class LogPair.
*/

#include <Settings.hpp>
#include <src/LogPair.hpp>

LogPair::LogPair(float _x, float _y, std::shared_ptr<GameMode> _game_mode, int _move) noexcept
    : x{_x}, y{_y}, game_mode{_game_mode},
      top{x, y + Settings::LOG_HEIGHT, true},
      bottom{x, y + Settings::LOGS_GAP + Settings::LOG_HEIGHT, false},
      closing{true}, vy{0.f}, move{_move}
{

}

bool LogPair::collides(const sf::FloatRect& rect) const noexcept
{
    return top.get_collision_rect().intersects(rect) || bottom.get_collision_rect().intersects(rect);
}

void LogPair::update(float dt) noexcept
{
    x += -Settings::MAIN_SCROLL_SPEED * dt;

//init hard
    if(move == 2)
        game_mode->update_logs(dt,&vy,&y,&closing);
//end hard

    top.update(x,y + Settings::LOG_HEIGHT + vy);
    bottom.update(x,y + Settings::LOG_HEIGHT + Settings::LOGS_GAP - vy);
}

void LogPair::render(sf::RenderTarget& target) const noexcept
{
    top.render(target);
    bottom.render(target);
}

bool LogPair::is_out_of_game() const noexcept
{
    return x < -Settings::LOG_WIDTH;
}

bool LogPair::update_scored(const sf::FloatRect& rect) noexcept
{
    if (scored)
    {
        return false;
    }

    if (rect.left > x + Settings::LOG_WIDTH)
    {
        scored = true;
        return true;
    }

    return false;
}

void LogPair::reset(float _x, float _y) noexcept
{
    x = _x;
    y = _y;
    scored = false;
}

/*
float LogPair::get_vy() const noexcept
{
    return vy;
}

float LogPair::get_y() const noexcept
{
    return y;
}


void LogPair::set_vy(float _vy) noexcept
{
    vy = _vy;
}
bool LogPair::get_closing() const noexcept
{
    return closing;
}
void LogPair::set_closing(bool _closing) noexcept
{
    closing = _closing;
}
*/

void LogPair::change_move_status() noexcept
{
    move = rand() % 4;
    vy = 0;
}
