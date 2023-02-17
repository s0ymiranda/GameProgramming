import random
from typing import TypeVar

from gale.factory import Factory

import settings
from src.Cannon_Fire import Cannon_Fire
from src.powerups.PowerUp import PowerUp


class Cannon(PowerUp):

    def __init__(self, x: int, y: int) -> None:
        super().__init__(x, y, 6)
        self.test_factory = Factory(Cannon_Fire)

    def take(self, play_state: TypeVar("PlayState")) -> None:
        paddle = play_state.paddle

        if len(play_state.cannons_fire) != 0:
            self.in_play = False
            return
        b = self.test_factory.create(paddle.x, paddle.y)
        c = self.test_factory.create(paddle.x + paddle.width, paddle.y)
        settings.SOUNDS["paddle_hit"].stop()
        settings.SOUNDS["paddle_hit"].play()
        play_state.cannons_fire.append(b)
        play_state.cannons_fire.append(c)

        self.in_play = False