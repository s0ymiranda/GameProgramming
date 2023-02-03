/*
    ISPPJ1 2023
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the declaration of the class World.
*/

#pragma once

#include <list>
#include <memory>
#include <random>

#include <SFML/Graphics.hpp>

#include <src/Factory.hpp>
#include <src/LogPair.hpp>

#include <src/game_modes/GameMode.hpp>
#include <src/game_modes/GameModeHard.hpp>
#include <src/game_modes/GameModeNormal.hpp>

class World
{
public:

    World(std::shared_ptr<GameMode> _game_mode = nullptr, bool _generate_logs = false) noexcept;

    World(const World& world) = delete;

    World& operator = (World) = delete;

    void reset(std::shared_ptr<GameMode> _game_mode, bool _generate_logs) noexcept;

    bool collides(const sf::FloatRect& rect) const noexcept;

    bool update_scored(const sf::FloatRect& rect) noexcept;

    void update(float dt) noexcept;

    //void set_gamemode(sha) noexcept;

    void render(sf::RenderTarget& target) const noexcept;
    
    //std::list<std::shared_ptr<LogPair>> get_logs() noexcept;

private:
    bool generate_logs;
    std::shared_ptr<GameMode> game_mode;

    sf::Sprite background;
    sf::Sprite ground;

    float background_x{0.f};
    float ground_x{0.f};

    Factory<LogPair> log_factory;
    //Factory<LogPairHard> log_hard_factory;
    
    //Factory<LogPair> log_hard_factory{std::make_shared<LogPairHard>()};

    //std::shared_ptr<LogPair> logs_hard{std::make_shared<LogPairHard>()};

    //std::list<std::shared_ptr<LogPairHard>> logs;
    std::list<std::shared_ptr<LogPair>> logs;
    //std::list<std::shared_ptr<LogPairHard>> logs_hard;

    std::mt19937 rng;

    float logs_spawn_timer{0.f};
    float last_log_y{0.f};
};
