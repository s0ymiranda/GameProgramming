/*
    ISPPJ1 2023
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of the class Bird.
*/

#include <Settings.hpp>
#include <src/Bird.hpp>

Bird::Bird(float _x, float _y, float w, float h) noexcept
    : x{_x}, y{_y}, width{w}, height{h}, vy{0.f}, sprite{Settings::textures["bird"]}
{
    sprite.setPosition(x, y);
}

sf::FloatRect Bird::get_collision_rect() const noexcept
{
    return sf::FloatRect{x, y, width, height};
}

void Bird::jump() noexcept
{
    if (!jumping)
    {
        jumping = true;
    }
}

void Bird::move_on_x(float _x) noexcept
{
    if( x > 0)
        x += _x;
    else 
        x = 1;
}

void Bird::update(float dt) noexcept
{
    vy += Settings::GRAVITY * dt;

    if (y > Settings::VIRTUAL_HEIGHT)
    {
        y -= Settings::BIRD_HEIGHT + Settings::GROUND_HEIGHT;

        return;
    }
    if (jumping && y > 0 )
    {
        Settings::sounds["jump"].play();
        vy = -Settings::JUMP_TAKEOFF_SPEED;
        jumping = false;
    }
    y += vy * dt;
    sprite.setPosition(x, y);
}

void Bird::render(sf::RenderTarget& target) const noexcept
{
    target.draw(sprite);
}

sf::Sprite* Bird::get_sprite() noexcept
{
    return &sprite;
}