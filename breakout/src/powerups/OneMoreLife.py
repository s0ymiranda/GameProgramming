from typing import TypeVar
import settings
from src.powerups.PowerUp import PowerUp


class OneMoreLife(PowerUp):

    def __init__(self, x: int, y: int) -> None:
        super().__init__(x, y, 2)

    def take(self, play_state: TypeVar("PlayState")) -> None:

        settings.SOUNDS["life"].play()
        play_state.lives = min(3,play_state.lives + 1)
        self.in_play = False