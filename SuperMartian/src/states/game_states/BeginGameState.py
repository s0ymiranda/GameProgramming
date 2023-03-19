from typing import Dict, Any

import pygame

from gale.input_handler import InputHandler, InputData
from gale.state_machine import BaseState
from gale.text import render_text
from gale.timer import Timer

import settings
from src.Player import Player



class BeginGameState(BaseState):
    def enter(self, level, player) -> None:
        self.level = level
        self.player = player
        self.transition_alpha = 255
        self.screen_alpha_surface = pygame.Surface(
            (settings.VIRTUAL_WIDTH, settings.VIRTUAL_HEIGHT), pygame.SRCALPHA
        )
        settings.SOUNDS["turn_off"].stop()
        settings.SOUNDS["turn_off"].play()
        Timer.tween(
            0.50,
            [(self, {"transition_alpha": 0})],
            on_finish=lambda:Timer.tween(
                0.50,
                [(self, {"transition_alpha": 255})],
                on_finish=lambda: self.state_machine.change(
                    "play", level=self.level+1, player = self.player, next_level = True
                )
            ),
        ),
            
    def render(self, surface: pygame.Surface) -> None:
        pygame.draw.rect(
            self.screen_alpha_surface,
            (255, 255, 255, self.transition_alpha),
            pygame.Rect(0, 0, settings.VIRTUAL_WIDTH, settings.VIRTUAL_HEIGHT),
        )
        surface.blit(self.screen_alpha_surface, (0, 0))
