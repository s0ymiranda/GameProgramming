"""
ISPPJ1 2023
Study Case: Breakout

Author: Alejandro Mujica
alejandro.j.mujic4@gmail.com

This file contains the class to define the Play state.
"""
import random

import pygame

from gale.factory import AbstractFactory
from gale.state_machine import BaseState
from gale.input_handler import InputHandler, InputData, InputData
from gale.text import render_text

import settings
import src.powerups

class PlayState(BaseState):
    def enter(self, **params: dict):
        self.level = params["level"]
        self.score = params["score"]
        self.lives = params["lives"]
        self.paddle = params["paddle"]
        self.balls = params["balls"]
        self.brickset = params["brickset"]
        self.live_factor = params["live_factor"]
        self.points_to_next_live = params["points_to_next_live"]
        self.points_to_next_grow_up = (
            self.score
            + settings.PADDLE_GROW_UP_POINTS * (self.paddle.size + 1) * self.level
        )
        self.powerups = params.get("powerups", [])
        self.cannons_fire = params.get("cannons_fire", [])
        self.sticky = params.get("sticky",False)
        self.sticky_timer = params.get("sticky_timer",5)
        self.counter = params.get("counter",0)        
        if not params.get("resume", False):
            self.balls[0].vx = random.randint(-80, 80)
            self.balls[0].vy = random.randint(-170, -100)
            settings.SOUNDS["paddle_hit"].play()

        self.powerups_abstract_factory = AbstractFactory("src.powerups")

        InputHandler.register_listener(self)

    def exit(self) -> None:
        InputHandler.unregister_listener(self)

    def update(self, dt: float) -> None:
        self.paddle.update(dt)

        for cannon_fire in self.cannons_fire:
            cannon_fire.update(dt,self)
            cannon_fire.solve_world_boundaries()
            # Check collision with brickset
            if not cannon_fire.collides(self.brickset):
                continue
            
            while True:
                brick = self.brickset.get_colliding_brick(cannon_fire.get_collision_rect())

                if brick is None:
                    break           
                
                brick.hit()
                self.score += brick.score()

        #Counter for sticky powerup        
        if self.sticky:
            self.counter += dt
        if self.counter >= self.sticky_timer: 
            for ball in self.balls:
                if ball.sticked_on_paddle:
                    ball.vx = random.randint(-80, 80)
                    ball.vy = random.randint(-170, -100)
                    ball.sticked_on_paddle = False
            self.counter = 0
            self.sticky = False

        for ball in self.balls:
            ball.update(dt)
            ball.solve_world_boundaries()

            # Check collision with the paddle
            if ball.collides(self.paddle):
                if self.sticky:
                    if not ball.sticked_on_paddle and ball.vy > 0:
                        ball.sticky(self.paddle)
                else:
                    settings.SOUNDS["paddle_hit"].stop()
                    settings.SOUNDS["paddle_hit"].play()
                    ball.rebound(self.paddle)
                    ball.push(self.paddle)
            if(ball.sticked_on_paddle):
                ball.x = self.paddle.x + ball.sticked_position

            # Check collision with brickset
            if not ball.collides(self.brickset):
                continue

            brick = self.brickset.get_colliding_brick(ball.get_collision_rect())

            if brick is None:
                continue

            brick.hit()
            self.score += brick.score()
            ball.rebound(brick)

            # Check earn life
            if self.score >= self.points_to_next_live:
                settings.SOUNDS["life"].play()
                self.lives = min(3, self.lives + 1)
                self.live_factor += 0.5
                self.points_to_next_live += settings.LIVE_POINTS_BASE * self.live_factor

            # Check growing up of the paddle
            if self.score >= self.points_to_next_grow_up:
                settings.SOUNDS["grow_up"].play()
                self.points_to_next_grow_up += (
                    settings.PADDLE_GROW_UP_POINTS * (self.paddle.size + 1) * self.level
                )
                self.paddle.inc_size()

            #Chance to generate a powerup
            if random.random() < 0.4:
                r = brick.get_collision_rect()
                random_number = random.random()
                if random_number <= 1/3:
                    #Chance to generate two more balls
                    create = "TwoMoreBall"
                elif random_number > 1/3 and random_number <= 2/3:
                    #chance to get Sticky paddle
                    create = "StickyPaddle"
                else:
                    #chance to generate cannons
                    create = "Cannon"
                self.powerups.append(
                    self.powerups_abstract_factory.get_factory(create).create(
                        r.centerx - 8, r.centery - 8
                    )
                )
            elif self.lives == 1 and random.random() < 0.1:
                r = brick.get_collision_rect()
                self.powerups.append(
                    self.powerups_abstract_factory.get_factory("OneMoreLife").create(
                        r.centerx - 8, r.centery - 8
                    )
                )
        # Removing all balls that are not in play
        self.balls = [ball for ball in self.balls if ball.in_play]

        self.brickset.update(dt)

        if not self.balls:
            self.lives -= 1
            if self.lives == 0:
                self.state_machine.change("game_over", score=self.score)
            else:
                self.paddle.dec_size()
                self.state_machine.change(
                    "serve",
                    level=self.level,
                    score=self.score,
                    lives=self.lives,
                    paddle=self.paddle,
                    brickset=self.brickset,
                    points_to_next_live=self.points_to_next_live,
                    live_factor=self.live_factor,
                )

        # Update powerups
        for powerup in self.powerups:
            powerup.update(dt)

            if powerup.collides(self.paddle):
                powerup.take(self)

        # Remove powerups that are not in play
        self.powerups = [p for p in self.powerups if p.in_play]

        #remove cannons fire that are not in play
        self.cannons_fire = [p for p in self.cannons_fire if p.in_play]

        # Check victory
        if self.brickset.size == 1 and next(
            (True for _, b in self.brickset.bricks.items() if b.broken), False
        ):
            self.state_machine.change(
                "victory",
                lives=self.lives,
                level=self.level,
                score=self.score,
                paddle=self.paddle,
                balls=self.balls,
                points_to_next_live=self.points_to_next_live,
                live_factor=self.live_factor,
            )

    def render(self, surface: pygame.Surface) -> None:
        heart_x = settings.VIRTUAL_WIDTH - 120

        i = 0
        # Draw filled hearts
        while i < self.lives:
            surface.blit(
                settings.TEXTURES["hearts"], (heart_x, 5), settings.FRAMES["hearts"][0]
            )
            heart_x += 11
            i += 1

        # Draw empty hearts
        while i < 3:
            surface.blit(
                settings.TEXTURES["hearts"], (heart_x, 5), settings.FRAMES["hearts"][1]
            )
            heart_x += 11
            i += 1

        render_text(
            surface,
            f"Score: {self.score}",
            settings.FONTS["tiny"],
            settings.VIRTUAL_WIDTH - 80,
            5,
            (255, 255, 255),
        )

        self.brickset.render(surface)

        self.paddle.render(surface)

        for ball in self.balls:
            ball.render(surface)

        for powerup in self.powerups:
            powerup.render(surface)

        #render cannons fire
        for cannon_fire in self.cannons_fire:
            cannon_fire.render(surface)

        if self.sticky:
            render_text(
                surface,
                f"Sticky time: {int(6 - self.counter)}",
                settings.FONTS["tiny"],
                20,
                5,
                (255, 255, 255),
            )

    def on_input(self, input_id: str, input_data: InputData) -> None:
        if input_id == "move_left" or input_id == "move_left_v2":
            if input_data.pressed:
                self.paddle.vx = -settings.PADDLE_SPEED
            elif input_data.released and self.paddle.vx < 0:
                self.paddle.vx = 0
        elif input_id == "move_right" or input_id == "move_right_v2":
            if input_data.pressed:
                self.paddle.vx = settings.PADDLE_SPEED
            elif input_data.released and self.paddle.vx > 0:
                self.paddle.vx = 0
        elif input_id == "shoot" and len(self.cannons_fire) != 0:
            for cannon_fire in self.cannons_fire:
                cannon_fire.texture = settings.TEXTURES["cannon_fire"]
                cannon_fire.vy = -140
        elif input_id == "release_balls" and self.sticky and input_data.pressed:
            for ball in self.balls:
                if ball.sticked_on_paddle:    
                    ball.vx = random.randint(-80, 80)
                    ball.vy = random.randint(-170, -100)
                    settings.SOUNDS["paddle_hit"].play()
                    ball.sticked_on_paddle = False



        elif input_id == "pause" and input_data.pressed:
            self.state_machine.change(
                "pause",
                level=self.level,
                score=self.score,
                lives=self.lives,
                paddle=self.paddle,
                balls=self.balls,
                brickset=self.brickset,
                points_to_next_live=self.points_to_next_live,
                live_factor=self.live_factor,
                powerups=self.powerups,
                cannons_fire = self.cannons_fire,
                sticky = self.sticky,
                sticky_timer = self.sticky_timer,
                counter = self.counter,
            )
