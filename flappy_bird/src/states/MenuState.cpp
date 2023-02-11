#include <Settings.hpp>
#include <src/text_utilities.hpp>
#include <src/states/MenuState.hpp>
#include <src/states/StateMachine.hpp>

MenuState::MenuState(StateMachine* sm) noexcept
    : BaseState{sm}
{

}

void MenuState::enter(std::shared_ptr<World> _world, std::shared_ptr<Bird> _bird, std::shared_ptr<GameMode> _game_mode,int _score) noexcept
{
    
    if(_bird == nullptr)
        world = std::make_shared<World>(nullptr, false, false);
    else 
        world = _world;
    score = _score;
    bird = _bird;
}

void MenuState::handle_inputs(const sf::Event& event) noexcept
{
    if (event.key.code == sf::Keyboard::N)
    {
        state_machine->change_state("count_down",nullptr,nullptr,game_mode_normal,0);
    }
    else if(event.key.code == sf::Keyboard::H)
    {
        state_machine->change_state("count_down",nullptr,nullptr,game_mode_hard,0);
    }
}

void MenuState::update(float dt) noexcept
{
    world->update(dt);
}

void MenuState::render(sf::RenderTarget& target) const noexcept
{
    world->render(target);
    render_text(target, Settings::VIRTUAL_WIDTH / 2, Settings::VIRTUAL_HEIGHT / 3, "Flappy Bird", Settings::FLAPPY_TEXT_SIZE, "flappy", sf::Color::White, true);
    render_text(target, Settings::VIRTUAL_WIDTH / 2, 2 * Settings::VIRTUAL_HEIGHT / 3, "Press N to Play Normal", Settings::MEDIUM_TEXT_SIZE, "font", sf::Color::White, true);
    render_text(target, Settings::VIRTUAL_WIDTH / 2, 2.25 * Settings::VIRTUAL_HEIGHT / 3, "Press H to Play Hard", Settings::MEDIUM_TEXT_SIZE, "font", sf::Color::White, true);
}