#pragma once

#include <src/World.hpp>
#include <src/states/BaseState.hpp>
#include <src/game_modes/GameMode.hpp>
#include <src/game_modes/GameModeHard.hpp>
#include <src/game_modes/GameModeNormal.hpp>
 
class MenuState: public BaseState
{
public:
    MenuState(StateMachine* sm) noexcept;

    void enter(std::shared_ptr<World> _world = nullptr, std::shared_ptr<Bird> _bird = nullptr, std::shared_ptr<GameMode> _game_mode = nullptr, int score = 0) noexcept override;

    void handle_inputs(const sf::Event& event) noexcept override;

    void update(float dt) noexcept override;

    void render(sf::RenderTarget& target) const noexcept override;

private:

    std::shared_ptr<GameMode> game_mode_normal{std::make_shared<GameModeNormal>()};
    std::shared_ptr<GameMode> game_mode_hard{std::make_shared<GameModeHard>()};
    std::shared_ptr<World> world;
    std::shared_ptr<Bird> bird;

    int score;
};
