"""
ISPPJ1 2023
Study Case: Super Martian (Platformer)

Author: Alejandro Mujica
alejandro.j.mujic4@gmail.com

This file contains the class PlayState.
"""
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
from src.Tile import Tile


class PlayState(BaseState):
    def enter(self, **enter_params: Dict[str, Any]) -> None:
        self.level = enter_params.get("level")
        self.camera = enter_params.get(
            "camera", Camera(0, 0, settings.VIRTUAL_WIDTH, settings.VIRTUAL_HEIGHT)
        )
        self.game_level = enter_params.get("game_level")
        if self.game_level is None:
            self.game_level = GameLevel(self.level, self.camera)
            if self.level == 1:
                pygame.mixer.music.load(settings.BASE_DIR / "sounds/music_grassland.ogg")
            else:
                pygame.mixer.music.load(settings.BASE_DIR / "sounds/Resting_Grounds.mp3")
                
            pygame.mixer.music.play(loops=-1)

        self.tilemap = self.game_level.tilemap
        self.player = enter_params.get("player")
        if self.player is None:
            self.player = Player(0, settings.VIRTUAL_HEIGHT - 66, self.game_level)
            self.player.change_state("idle")

        if self.level == 1:
            self.timer = enter_params.get("timer", 30)
        elif self.level == 2:
            self.timer = enter_params.get("timer", 60)

        def countdown_timer():
            self.timer -= 1

            if 0 < self.timer <= 5:
                settings.SOUNDS["timer"].play()

        Timer.every(1, countdown_timer)
        InputHandler.register_listener(self)

        #own try
        self.index_save = []

    def exit(self) -> None:
        InputHandler.unregister_listener(self)
        Timer.clear()

    def update(self, dt: float) -> None:
        if self.player.is_dead or self.timer == 0:
            pygame.mixer.music.stop()
            pygame.mixer.music.unload()
            self.state_machine.change("game_over", self.player)

        self.player.update(dt)

        self.camera.x = max(
            0,
            min(
                self.player.x + 8 - settings.VIRTUAL_WIDTH // 2,
                self.tilemap.width - settings.VIRTUAL_WIDTH,
            ),
        )
        self.camera.y = max(
            0,
            min(
                self.player.y + 10 - settings.VIRTUAL_HEIGHT // 2,
                self.tilemap.height - settings.VIRTUAL_HEIGHT,
            ),
        )

        self.game_level.update(dt)

        for creature in self.game_level.creatures:
            if self.player.collides(creature):
                self.player.is_dead = True

        for item in self.game_level.items:
            if not item.in_play or not item.collidable:
                continue

            if self.player.collides(item):
                item.on_collide(self.player)
                item.on_consume(self.player)

        #New

        if self.player.score >= 100 and self.level == 1:
            
            for item in self.game_level.items:
                if item.frame_index == 71:
                    item.in_play = True
                else:
                    item.in_play = False
            
            if self.player.key_taken:
                if self.level == 1:
                    self.player.key_taken = False
                    self.state_machine.change("begin",self.level)

            if len(self.index_save) == 0:
                settings.SOUNDS["secret_discovered"].stop()
                settings.SOUNDS["secret_discovered"].play()
                pygame.mixer.music.pause()
                pygame.mixer.music.unload()
                pygame.mixer.music.load(settings.BASE_DIR / "sounds" / "Resting_Grounds.mp3")
                Timer.clear()
                Timer.after(2.0,lambda: self.play_music())

            for g in range(len(self.tilemap.layers)):
                for i in range(len(self.tilemap.layers[g])):
                    for j in range(len(self.tilemap.layers[g][i])):
                        if not self.tilemap.layers[g][i][j].in_play:
                            self.tilemap.layers[g][i][j].solidness = {"top":True,"right":True,"bottom":True,"left":True}
                            self.tilemap.layers[g][i][j].in_play = True
                            self.index_save.append(g)
                            self.index_save.append(i)
                            self.index_save.append(j)
                            break

            for item in self.game_level.items:
                if item.frame_index == 71 and item.visible:
                    self.tilemap.layers[self.index_save[0]][self.index_save[1]][self.index_save[2]].frame_index = 75

    def play_music(self):
        pygame.mixer.music.play()
        pygame.mixer.music.play(loops=-1)

    def render(self, surface: pygame.Surface) -> None:
        world_surface = pygame.Surface((self.tilemap.width, self.tilemap.height))
        self.game_level.render(world_surface)
        self.player.render(world_surface)
        surface.blit(world_surface, (-self.camera.x, -self.camera.y))

        render_text(
            surface,
            f"Score: {self.player.score}",
            settings.FONTS["small"],
            5,
            5,
            (255, 255, 255),
            shadowed=True,
        )

        render_text(
            surface,
            f"Time: {self.timer}",
            settings.FONTS["small"],
            settings.VIRTUAL_WIDTH - 60,
            5,
            (255, 255, 255),
            shadowed=True,
        )

    def on_input(self, input_id: str, input_data: InputData) -> None:
        if input_id == "pause" and input_data.pressed:
            self.state_machine.change(
                "pause",
                level=self.level,
                camera=self.camera,
                game_level=self.game_level,
                player=self.player,
                timer=self.timer,
            )
