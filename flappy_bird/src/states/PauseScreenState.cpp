#include <Settings.hpp>
#include <src/text_utilities.hpp>
#include <src/states/StateMachine.hpp>
#include <src/states/PauseScreenState.hpp>

PauseScreenState::PauseScreenState(StateMachine* sm) noexcept
    : BaseState{sm}
{

}

void PauseScreenState::enter(std::shared_ptr<World> _world, std::shared_ptr<Bird> _bird) noexcept
{
    world = _world;
   
}


void PauseScreenState::handle_inputs(const sf::Event& event) noexcept
{
    if (event.key.code == sf::Keyboard::Enter)
    {
        state_machine->change_state("count_down");
    }
}

void PauseScreenState::update(float dt) noexcept
{
    bird->update(dt);
    world->update(dt);
}

void PauseScreenState::render(sf::RenderTarget& target) const noexcept 
{
    world->render(target);
    render_text(target, Settings::VIRTUAL_WIDTH / 2, Settings::VIRTUAL_HEIGHT / 3, "Pause", Settings::FLAPPY_TEXT_SIZE, "flappy", sf::Color::White, true);
    render_text(target, Settings::VIRTUAL_WIDTH / 2, 2 * Settings::VIRTUAL_HEIGHT / 3, "Press Enter to start", Settings::MEDIUM_TEXT_SIZE, "font", sf::Color::White, true);
}