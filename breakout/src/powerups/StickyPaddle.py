import random
from typing import TypeVar

from gale.factory import Factory

import settings
from src.Ball import Ball
from src.Paddle import Paddle
from src.powerups.PowerUp import PowerUp


class StickyPaddle(PowerUp):
    """
    Power-up to add two more ball to the game.
    """

    def __init__(self, x: int, y: int) -> None:
        super().__init__(x, y, 7)


    def take(self, play_state: TypeVar("PlayState")) -> None:

        play_state.sticky = True
        
        self.in_play = False
