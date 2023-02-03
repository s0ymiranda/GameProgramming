/*
    ISPPJ1 2023
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of the class PlayingBaseState.
*/

#include <Settings.hpp>
#include <src/text_utilities.hpp>
#include <src/states/StateMachine.hpp>
#include <src/states/PlayingState.hpp>

PlayingState::PlayingState(StateMachine *sm) noexcept
    : BaseState{sm}
{
}

void PlayingState::enter(std::shared_ptr<World> _world, std::shared_ptr<Bird> _bird, std::shared_ptr<GameMode> _gameMode, int _score) noexcept
{
    world = _world;
    game_mode = _gameMode;
    world->reset(game_mode, true);
    score = _score;

    if (_bird == nullptr)
    {
        bird = std::make_shared<Bird>(
            Settings::VIRTUAL_WIDTH / 2 - Settings::BIRD_WIDTH / 2, Settings::VIRTUAL_HEIGHT / 2 - Settings::BIRD_HEIGHT / 2,
            Settings::BIRD_WIDTH, Settings::BIRD_HEIGHT);
    }
    else
    {
        bird = _bird;
    }
}

void PlayingState::handle_inputs(const sf::Event &event) noexcept
{
    /*if (event.type == sf::Event::MouseButtonPressed && event.mouseButton.button == sf::Mouse::Left)
    {
        bird->jump();
    }*/
    if ((event.type == sf::Event::MouseButtonPressed && event.mouseButton.button == sf::Mouse::Left)
        || (event.type == sf::Event::KeyPressed && event.key.code == sf::Keyboard::Space))
    {
        bird->jump();
    }
    if ((event.type == sf::Event::KeyPressed && event.key.code == sf::Keyboard::Escape))
    {
        state_machine->change_state("pause",world,bird,game_mode,score);
    }
    game_mode->handle_inputs(event);

}

void PlayingState::update(float dt) noexcept
{
    bird->update(dt);
    world->update(dt);

    if (world->collides(bird->get_collision_rect()))
    {
        Settings::sounds["explosion"].play();
        Settings::sounds["hurt"].play();
        //std::shared_ptr<GameMode> game_mode_hard{std::make_shared<GameModeHard>()};
        game_mode->reset();
        state_machine->change_state("count_down",nullptr,nullptr,game_mode);
        //state_machine->change_state("menu",nullptr,nullptr,game_mode);
    }

    if (world->update_scored(bird->get_collision_rect()))
    {
        ++score;
        Settings::sounds["score"].play();
    }

    game_mode->update(dt,bird);
    //game_mode->update_logs(dt,world->get_logs());
    //game_mode->update_logs(dt,);
}

void PlayingState::render(sf::RenderTarget &target) const noexcept
{
    world->render(target);
    bird->render(target);
    render_text(target, 20, 10, "Score: " + std::to_string(score), Settings::FLAPPY_TEXT_SIZE, "flappy", sf::Color::White);
}