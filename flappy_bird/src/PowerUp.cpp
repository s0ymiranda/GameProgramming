#include <Settings.hpp>
#include <src/PowerUp.hpp>

PowerUp::PowerUp(float _x, float _y) noexcept
    : x{_x}, y{_y}, sprite{Settings::textures["powerup"]}
{

}

sf::FloatRect PowerUp::get_collision_rect() const noexcept
{
    return sf::FloatRect{ x + 10,  y + 10, Settings::POWERUP_WIDTH - 10, Settings::POWERUP_HEIGHT - 10};
}


void PowerUp::update(float dt) noexcept
{
    x += -Settings::MAIN_SCROLL_SPEED * dt;

    sprite.setPosition(x,y);
}

void PowerUp::render(sf::RenderTarget& target) const noexcept
{
    target.draw(sprite);
}

bool PowerUp::is_out_of_game() const noexcept
{
    return x < -Settings::POWERUP_WIDTH;
}
void PowerUp::reset(float _x, float _y) noexcept
{
    x = _x;
    y = _y;
}