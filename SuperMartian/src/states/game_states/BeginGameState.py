from typing import Dict, Any

import pygame

from gale.input_handler import InputHandler, InputData
from gale.state_machine import BaseState
from gale.text import render_text
from gale.timer import Timer

import settings
from src.Camera import Camera
from src.GameLevel import GameLevel
from src.Player import Player



class BeginGameState(BaseState):
    def enter(self, level) -> None:
        self.level = level
        self.transition_alpha = 255
        self.level_transition = 0
        # A surface that supports alpha for the screen
        self.screen_alpha_surface = pygame.Surface(
            (settings.VIRTUAL_WIDTH, settings.VIRTUAL_HEIGHT), pygame.SRCALPHA
        )

        # first, over a period of 1 second, transition out alpha to 0
        # (fade-in).
        Timer.tween(
            1,
            [(self, {"transition_alpha": 0})],
            # once that is finished, start a transition of our text label to
            # center of the screen over 0.25 seconds
            on_finish=lambda: Timer.tween(
                0.25,
                [(self, {"level_transition": settings.VIRTUAL_HEIGHT // 2 - 30})],
                # after that, pause for 1.5 second with Timer.after
                on_finish=lambda: Timer.after(
                    1.5,
                    # Then, animate the label going down past the bottom edge
                    lambda: Timer.tween(
                        0.25,
                        [(self, {"level_transition": settings.VIRTUAL_HEIGHT + 30})],
                        # We are ready to play
                        on_finish=lambda: self.state_machine.change(
                            "play", level=2
                        ),
                    ),
                ),
            ),
        )

    def render(self, surface: pygame.Surface) -> None:


        # our transition foregorund rectangle
        pygame.draw.rect(
            self.screen_alpha_surface,
            (255, 255, 255, self.transition_alpha),
            pygame.Rect(0, 0, settings.VIRTUAL_WIDTH, settings.VIRTUAL_HEIGHT),
        )
        surface.blit(self.screen_alpha_surface, (0, 0))
