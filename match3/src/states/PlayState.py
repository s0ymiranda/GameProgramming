"""
ISPPJ1 2023
Study Case: Match-3

Author: Alejandro Mujica
alejandro.j.mujic4@gmail.com

This file contains the class PlayState.
"""
from typing import Dict, Any, List

import pygame

from gale.input_handler import InputHandler, InputData
from gale.state_machine import BaseState
from gale.text import render_text
from gale.timer import Timer
from src.Tile import Tile

import settings


class PlayState(BaseState):
    def enter(self, **enter_params: Dict[str, Any]) -> None:
        self.level = enter_params["level"]
        self.board = enter_params["board"]
        self.score = enter_params["score"]

        #start testing
        self.on_motion = False
        self.selected_tile_i = 0
        self.selected_tile_j = 0
        self.already_moving = "none"
        self.tile1 = None
        self.tile2 = None
        self.original_x_and_y_tile1 = None
        self.original_x_and_y_tile2 = None

        self.time_waiting = 0
        #end testing

        # Position in the grid which we are highlighting
        self.board_highlight_i1 = -1
        self.board_highlight_j1 = -1
        self.board_highlight_i2 = -1
        self.board_highlight_j2 = -1

        self.highlighted_tile = False

        self.active = True

        self.timer = settings.LEVEL_TIME

        self.goal_score = self.level * 1.25 * 1000

        # A surface that supports alpha to highlight a selected tile
        self.tile_alpha_surface = pygame.Surface(
            (settings.TILE_SIZE, settings.TILE_SIZE), pygame.SRCALPHA
        )
        pygame.draw.rect(
            self.tile_alpha_surface,
            (255, 255, 255, 96),
            pygame.Rect(0, 0, settings.TILE_SIZE, settings.TILE_SIZE),
            border_radius=7,
        )

        # A surface that supports alpha to draw behind the text.
        self.text_alpha_surface = pygame.Surface((212, 136), pygame.SRCALPHA)
        pygame.draw.rect(
            self.text_alpha_surface, (56, 56, 56, 234), pygame.Rect(0, 0, 212, 136)
        )

        def decrement_timer():
            self.timer -= 1
            self.time_waiting += 1
            # Play warning sound on timer if we get low
            if self.timer <= 5:
                settings.SOUNDS["clock"].play()

        Timer.every(1, decrement_timer)

        InputHandler.register_listener(self)

    def exit(self) -> None:
        InputHandler.unregister_listener(self)

    def update(self, _: float) -> None:

        if self.timer <= 0:
            Timer.clear()
            settings.SOUNDS["game-over"].play()
            self.state_machine.change("game-over", score=self.score)

        if self.score >= self.goal_score:
            Timer.clear()
            settings.SOUNDS["next-level"].play()
            self.state_machine.change("begin", level=self.level + 1, score=self.score)

        while not self.board.ExistMatch():
            self.board.RecreateBoard()
            self.board.MarkMatches()

    def render(self, surface: pygame.Surface) -> None:
        self.board.render(surface)

        if not self.on_motion and self.time_waiting >= 1:
            for g in range(8):
                for a in range(8):
                    tile = self.board.tiles[g][a]
                    if tile.can_match:
                        x = tile.j * settings.TILE_SIZE + self.board.x
                        y = tile.i * settings.TILE_SIZE + self.board.y
                        surface.blit(self.tile_alpha_surface, (x, y))                    

        surface.blit(self.text_alpha_surface, (16, 16))
        render_text(
            surface,
            f"Level: {self.level}",
            settings.FONTS["medium"],
            30,
            24,
            (99, 155, 255),
            shadowed=True,
        )
        render_text(
            surface,
            f"Score: {self.score}",
            settings.FONTS["medium"],
            30,
            52,
            (99, 155, 255),
            shadowed=True,
        )
        render_text(
            surface,
            f"Goal: {self.goal_score}",
            settings.FONTS["medium"],
            30,
            80,
            (99, 155, 255),
            shadowed=True,
        )
        render_text(
            surface,
            f"Timer: {self.timer}",
            settings.FONTS["medium"],
            30,
            108,
            (99, 155, 255),
            shadowed=True,
        )

    def on_input(self, input_id: str, input_data: InputData) -> None:

        if not self.active:
            return

        if input_id == "motion_left" and self.on_motion:
            if self.already_moving == "up" or self.already_moving == "down":
                return
            elif self.already_moving == "none":
                if self.selected_tile_j-1 >= 0:
                    self.already_moving = "left"
                    self.tile2 = self.board.tiles[self.selected_tile_i][self.selected_tile_j-1]
                    self.original_x_and_y_tile2 = self.tile2.x,self.tile2.y
                else:
                    return
            elif self.already_moving == "right":
                self.tile2 = self.board.tiles[self.selected_tile_i][self.selected_tile_j+1] 
            
            # Swap tiles
            x, y = input_data.position
            x = x * settings.VIRTUAL_WIDTH // settings.WINDOW_WIDTH - self.board.x - 16
            dif = self.tile1.x - x
            self.tile1.x = self.tile1.x - dif
            self.tile2.x = self.tile2.x + dif

        if input_id == "motion_right" and self.on_motion:
            if self.already_moving == "up" or self.already_moving == "down":
                return
            elif self.already_moving == "none":
                if self.selected_tile_j+1 < 8:
                    self.already_moving = "right"
                    self.tile2 = self.board.tiles[self.selected_tile_i][self.selected_tile_j+1]
                    self.original_x_and_y_tile2 = self.tile2.x,self.tile2.y
                else: 
                    return
            elif self.already_moving == "left":
                self.tile2 = self.board.tiles[self.selected_tile_i][self.selected_tile_j-1]
            
            # Swap tiles
            x, y = input_data.position
            x = x * settings.VIRTUAL_WIDTH // settings.WINDOW_WIDTH - self.board.x - 16
            dif = self.tile1.x - x
            self.tile1.x = self.tile1.x - dif
            self.tile2.x = self.tile2.x + dif
   
        if input_id == "motion_down" and self.on_motion:
            if self.already_moving == "left" or self.already_moving == "right":
                return
            elif self.already_moving == "none":
                if self.selected_tile_i + 1 < 8:
                    self.already_moving = "down"
                    self.tile2 = self.board.tiles[self.selected_tile_i+1][self.selected_tile_j]
                    self.original_x_and_y_tile2 = self.tile2.x,self.tile2.y
                else:
                    return
            elif self.already_moving == "up":
                self.tile2 = self.board.tiles[self.selected_tile_i-1][self.selected_tile_j]
            
            # Swap tiles
            x, y = input_data.position
            y = y * settings.VIRTUAL_HEIGHT // settings.WINDOW_HEIGHT - self.board.y - 16
            dif = self.tile1.y - y
            if (self.tile1.x,self.tile1.y) <= (self.original_x_and_y_tile2):
                self.tile1.y = self.tile1.y - dif
                self.tile2.y = self.tile2.y + dif
            

        if input_id == "motion_up" and self.on_motion:
            if self.already_moving == "left" or self.already_moving == "right":
                return
            elif self.already_moving == "none":
                if self.selected_tile_i - 1 >= 0:
                    self.already_moving = "up"
                    self.tile2 = self.board.tiles[self.selected_tile_i-1][self.selected_tile_j]
                    self.original_x_and_y_tile2 = self.tile2.x,self.tile2.y
                else:
                    return
            elif self.already_moving == "down":
                self.tile2 = self.board.tiles[self.selected_tile_i+1][self.selected_tile_j]

            # Swap tiles
            x, y = input_data.position
            y = y * settings.VIRTUAL_HEIGHT // settings.WINDOW_HEIGHT - self.board.y - 16
            dif = self.tile1.y - y
            if (self.tile1.x,self.tile1.y) >= (self.original_x_and_y_tile2):
                self.tile1.y = self.tile1.y - dif
                self.tile2.y = self.tile2.y + dif

        if input_id == "click" and input_data.released:

            # if self.tile1 == None:
            #     for index in range(8):
            #         for jndex in range(8):
            #             print(self.board.tiles[index][jndex].color,end=' ')
            #         print()

            if self.tile1 == None:
                #self.on_motion = False
                return

            if self.already_moving == "none":
                if self.tile1.variety == 7:
                    self.cross_power_up()
                elif self.tile1.variety == 8:
                    self.color_power_up()
                self.on_motion = False
                return

            def exchange(x1,y1,x2,y2):
                Timer.tween(
                    0.25,
                    [
                        (self.tile1, {"x": x1, "y": y1}),
                        (self.tile2, {"x": x2, "y": y2}),
                    ],
                )

                (
                    self.board.tiles[self.tile1.i][self.tile1.j],
                    self.board.tiles[self.tile2.i][self.tile2.j],
                ) = (
                    self.board.tiles[self.tile2.i][self.tile2.j],
                    self.board.tiles[self.tile1.i][self.tile1.j],
                )
                
                self.tile1.i, self.tile1.j, self.tile2.i, self.tile2.j = (
                    self.tile2.i,
                    self.tile2.j,
                    self.tile1.i,
                    self.tile1.j,
                )
                self.__calculate_matches([self.tile1, self.tile2])
                self.active = True

            def not_exchange(x1,y1,x2,y2):
                Timer.tween(
                    0.25,
                    [
                        (self.tile1, {"x": x1, "y": y1}),
                        (self.tile2, {"x": x2, "y": y2}),
                    ],
                )
                self.active = True

            self.active = False
            self.on_motion = False

            x1,y1 = self.original_x_and_y_tile1
            x2,y2 = self.original_x_and_y_tile2

            flag = True#self.board.CanMove(self.tile1,self.tile2.i,self.tile2.j)

            if self.already_moving == "left":
                if self.tile1.x < self.tile2.x and flag:
                    exchange(x2,y2,x1,y1)
                else:
                    not_exchange(x1,y1,x2,y2)
            elif self.already_moving == "right":
                if self.tile1.x > self.tile2.x and flag:
                    exchange(x2,y2,x1,y1)
                else:
                    not_exchange(x1,y1,x2,y2)
            elif self.already_moving == "down":
                if self.tile1.y > self.tile2.y and flag:
                    exchange(x2,y2,x1,y1)
                else:
                    not_exchange(x1,y1,x2,y2)
            elif self.already_moving == "up":
                if self.tile1.y < self.tile2.y and flag:
                    exchange(x2,y2,x1,y1)
                else:
                    not_exchange(x1,y1,x2,y2)
            self.already_moving = "none"

            self.board.MarkMatches()
            
        if input_id == "click" and input_data.pressed:
            self.on_motion = True
            pos_x, pos_y = input_data.position
            pos_x = pos_x * settings.VIRTUAL_WIDTH // settings.WINDOW_WIDTH
            pos_y = pos_y * settings.VIRTUAL_HEIGHT // settings.WINDOW_HEIGHT
            i = (pos_y - self.board.y) // settings.TILE_SIZE
            j = (pos_x - self.board.x) // settings.TILE_SIZE    
            if i >= 0 and i < 8 and j >= 0 and j < 8:
                self.selected_tile_i = i 
                self.selected_tile_j = j    
                self.tile1 = self.board.tiles[self.selected_tile_i][self.selected_tile_j]
                self.original_x_and_y_tile1 = self.tile1.x, self.tile1.y  
                self.time_waiting = 0
            else:
                self.tile1 = None
                self.on_motion = False

    def cross_power_up(self):
        settings.SOUNDS["match"].stop()
        settings.SOUNDS["match"].play()   
        self.board.cross_power_up(self.tile1.i,self.tile1.j)
        self.score += 15*25             
        falling_tiles = self.board.get_falling_tiles()
        Timer.tween(
            0.5,
            falling_tiles,
            on_finish=lambda: self.__calculate_matches(
                [item[0] for item in falling_tiles]
            ),
        )

    def color_power_up(self):
        settings.SOUNDS["match"].stop()
        settings.SOUNDS["match"].play()   
        quantity = self.board.color_power_up(self.tile1.color)
        self.score += quantity*50             
        falling_tiles = self.board.get_falling_tiles()
        Timer.tween(
            0.5,
            falling_tiles,
            on_finish=lambda: self.__calculate_matches(
                [item[0] for item in falling_tiles]
            ),
        )


    def __calculate_matches(self, tiles: List) -> None:
        matches = self.board.calculate_matches_for(tiles)

        if matches is None:
            self.active = True
            return

        settings.SOUNDS["match"].stop()
        settings.SOUNDS["match"].play()

        num = 0

        for match in matches:
            self.score += len(match) * 50
            if num < len(match):
                num = len(match)

        for match in matches:
            for t in match:
                if t.variety == 7:
                    self.cross_power_up()
                elif t.variety == 8:
                    self.color_power_up()

        self.board.remove_matches()
        
        # if num == 4:
        #     self.board.tiles[self.tile1.i][self.tile1.j] = Tile(
        #         self.tile1.i, self.tile1.j, self.tile1.color,7
        #     )
        # elif num > 4:
        #     self.board.tiles[self.tile1.i][self.tile1.j] = Tile(
        #         self.tile1.i, self.tile1.j, self.tile1.color,8
        #     )

        falling_tiles = self.board.get_falling_tiles()

        if num >= 4:
            for index in range(len(falling_tiles)):
                t,comp = falling_tiles[index]
                if t.i == self.tile1.i and t.j == self.tile1.j:
                    falling_tiles.pop(index)
                    break
            if num == 4:
                self.board.tiles[self.tile1.i][self.tile1.j] = Tile(
                    self.tile1.i, self.tile1.j, self.tile1.color,7
                )
            elif num > 4:
                self.board.tiles[self.tile1.i][self.tile1.j] = Tile(
                    self.tile1.i, self.tile1.j, self.tile1.color,8
                )

            for index in range(8):
                for jndex in range(8):
                    print(self.board.tiles[index][jndex].variety,end=' ')
                print()
        # for t in falling_tiles:
        #     t2,xd = t
        #     print( t2.i,t2.j)

        Timer.tween(
            0.25,
            falling_tiles,
            on_finish=lambda: self.__calculate_matches(
                [item[0] for item in falling_tiles]
            ),
        )

        self.board.MarkMatches()
