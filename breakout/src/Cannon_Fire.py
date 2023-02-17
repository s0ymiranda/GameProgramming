import random
from typing import Any, Tuple, Optional
from typing import TypeVar

import pygame

import settings

class Cannon_Fire:
    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y
        self.width = 8
        self.height = 8

        self.vx = 0
        self.vy = 0

        self.texture = settings.TEXTURES["cannon"]
        self.frame = 0
        self.in_play = True
        #self.actioned = False

    def get_collision_rect(self) -> pygame.Rect:
        return pygame.Rect(self.x, self.y, self.width, self.height)

    def solve_world_boundaries(self) -> None:
        r = self.get_collision_rect()

        if r.top < 0:
            settings.SOUNDS["hurt"].play()
            self.in_play = False
        elif r.top > settings.VIRTUAL_HEIGHT:
            settings.SOUNDS["hurt"].play()
            self.in_play = False

    def collides(self, another: Any) -> bool:
        return self.get_collision_rect().colliderect(another.get_collision_rect())

    def update(self, dt: float, play_state: TypeVar("PlayState")) -> None:
        self.y += self.vy * dt
        if self.vy == 0:
            if self.x >= play_state.paddle.x+ play_state.paddle.width/2 -8:
                self.x = play_state.paddle.x + play_state.paddle.width - 8
            else:
                self.x = play_state.paddle.x
        
    def render(self, surface):
        surface.blit(
            self.texture, (self.x, self.y), settings.FRAMES["cannons_fire"][self.frame]
        )
        #surface.blit(
        #    settings.TEXTURES["hearts"], (heart_x, 5), settings.FRAMES["hearts"][0]
        #)

    @staticmethod
    def get_intersection(r1: pygame.Rect, r2: pygame.Rect) -> Optional[Tuple[int, int]]:
        """
        Compute, if exists, the intersection between two
        rectangles.
        """
        if r1.x > r2.right or r1.right < r2.x or r1.bottom < r2.y or r1.y > r2.bottom:
            # There is no intersection
            return None

        # Compute x shift
        if r1.centerx < r2.centerx:
            x_shift = r2.x - r1.right
        else:
            x_shift = r2.right - r1.x

        # Compute y shift
        if r1.centery < r2.centery:
            y_shift = r2.y - r1.bottom
        else:
            y_shift = r2.bottom - r1.y

        return (x_shift, y_shift)

    def destroy(self, another: Any):
        br = self.get_collision_rect()
        sr = another.get_collision_rect()

        r = self.get_intersection(br, sr)

        if r is None:
            return

        self.in_play = False    