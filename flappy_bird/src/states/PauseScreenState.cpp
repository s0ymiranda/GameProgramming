/*
    ISPPJ1 2023
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the declaration of the class PauseScreenState.
*/

#include <Settings.hpp>
#include <src/text_utilities.hpp>
#include <src/states/StateMachine.hpp>
#include <src/states/PauseScreenState.hpp>

PauseScreenState::PauseScreenState(StateMachine* sm) noexcept
    : BaseState{sm}
{

}

void PauseScreenState::enter(std::shared_ptr<World> _world, std::shared_ptr<Bird> _bird, std::shared_ptr<GameMode> _gameMode, int _score) noexcept
{
    world = _world;
    bird = _bird;
    score = _score;
    game_mode = _gameMode;
}

void PauseScreenState::handle_inputs(const sf::Event& event) noexcept
{
    if (event.key.code == sf::Keyboard::Enter || event.key.code == sf::Keyboard::Escape)
    {
        state_machine->change_state("count_down",world,bird,game_mode,score);
    }
    if (event.key.code == sf::Keyboard::M)
    {
        state_machine->change_state("menu");
    }
}

void PauseScreenState::render(sf::RenderTarget& target) const noexcept 
{
    world->render(target);
    bird->render(target);
    render_text(target, Settings::VIRTUAL_WIDTH / 2, Settings::VIRTUAL_HEIGHT / 3, "Pause", Settings::FLAPPY_TEXT_SIZE, "flappy", sf::Color::White, true);
    render_text(target, Settings::VIRTUAL_WIDTH / 2, 2 * Settings::VIRTUAL_HEIGHT / 3, "Press Enter to resume game", Settings::MEDIUM_TEXT_SIZE, "font", sf::Color::White, true);
    render_text(target, Settings::VIRTUAL_WIDTH / 2, 2.3 * Settings::VIRTUAL_HEIGHT / 3, "Press M to go to menu", Settings::MEDIUM_TEXT_SIZE, "font", sf::Color::White, true);
}