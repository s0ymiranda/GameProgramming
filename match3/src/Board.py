"""
ISPPJ1 2023
Study Case: Match-3

Author: Alejandro Mujica
alejandro.j.mujic4@gmail.com

This file contains the class Board.
"""
from typing import List, Optional, Tuple, Any, Dict, Set

import pygame

import random

import settings
from src.Tile import Tile


class Board:
    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y
        self.possible_matches: List[List[Tile]] = []
        self.matches: List[List[Tile]] = []
        self.tiles: List[List[Tile]] = []
        self.__initialize_tiles()
        while not self.ExistMatch():
            self.__initialize_tiles()   

    def render(self, surface: pygame.Surface) -> None:
        for row in self.tiles:
            for tile in row:
                tile.render(surface, self.x, self.y)

    def __is_match_generated(self, i: int, j: int, color: int) -> bool:
        if (
            i >= 2
            and self.tiles[i - 1][j].color == color
            and self.tiles[i - 2][j].color == color
        ):
            return True

        return (
            j >= 2
            and self.tiles[i][j - 1].color == color
            and self.tiles[i][j - 2].color == color
        )

    def __initialize_tiles(self) -> None:
        self.tiles = [
            [None for _ in range(settings.BOARD_WIDTH)]
            for _ in range(settings.BOARD_HEIGHT)
        ]
        for i in range(settings.BOARD_HEIGHT):
            for j in range(settings.BOARD_WIDTH):
                color = random.randint(0, settings.NUM_COLORS - 1)
                while self.__is_match_generated(i, j, color):
                    color = random.randint(0, settings.NUM_COLORS - 1)

                self.tiles[i][j] = Tile(
                    i, j, color, random.randint(0, settings.NUM_VARIETIES - 1)
                )

    def RecreateBoard(self):
        self.__initialize_tiles()

    def __calculate_match_rec(self, tile: Tile) -> Set[Tile]:
        if tile in self.in_stack:
            return []

        self.in_stack.add(tile)

        color_to_match = tile.color

        ## Check horizontal match
        h_match: List[Tile] = []

        # Check left
        if tile.j > 0:
            left = max(0, tile.j - 2)
            for j in range(tile.j - 1, left - 1, -1):
                if self.tiles[tile.i][j].color != color_to_match:
                    break
                h_match.append(self.tiles[tile.i][j])

        # Check right
        if tile.j < settings.BOARD_WIDTH - 1:
            right = min(settings.BOARD_WIDTH - 1, tile.j + 2)
            for j in range(tile.j + 1, right + 1):
                if self.tiles[tile.i][j].color != color_to_match:
                    break
                h_match.append(self.tiles[tile.i][j])

        ## Check vertical match
        v_match: List[Tile] = []

        # Check top
        if tile.i > 0:
            top = max(0, tile.i - 2)
            for i in range(tile.i - 1, top - 1, -1):
                if self.tiles[i][tile.j].color != color_to_match:
                    break
                v_match.append(self.tiles[i][tile.j])

        # Check bottom
        if tile.i < settings.BOARD_HEIGHT - 1:
            bottom = min(settings.BOARD_HEIGHT - 1, tile.i + 2)
            for i in range(tile.i + 1, bottom + 1):
                if self.tiles[i][tile.j].color != color_to_match:
                    break
                v_match.append(self.tiles[i][tile.j])

        match: List[Tile] = []

        if len(h_match) >= 2:
            for t in h_match:
                if t not in self.in_match:
                    self.in_match.add(t)
                    match.append(t)

        if len(v_match) >= 2:
            for t in v_match:
                if t not in self.in_match:
                    self.in_match.add(t)
                    match.append(t)

        if len(match) > 0:
            if tile not in self.in_match:
                self.in_match.add(tile)
                match.append(tile)

        for t in match:
            match += self.__calculate_match_rec(t)

        self.in_stack.remove(tile)
        return match

    def calculate_matches_for(
        self, new_tiles: List[Tile]
    ) -> Optional[List[List[Tile]]]:
        self.in_match: Set[Tile] = set()
        self.in_stack: Set[Tile] = set()

        for tile in new_tiles:
            if tile in self.in_match:
                continue
            match = self.__calculate_match_rec(tile)
            if len(match) > 0:
                self.matches.append(match)

        delattr(self, "in_match")
        delattr(self, "in_stack")

        return self.matches if len(self.matches) > 0 else None

    def remove_matches(self) -> None:
        for match in self.matches:
            for tile in match:
                self.tiles[tile.i][tile.j] = None

        self.matches = []

    def cross_power_up(self,tile_i: int,tile_j : int):
        for j in range(8):
            self.tiles[tile_i][j] = None
        for i in range(8):
            self.tiles[i][tile_j] = None

    def color_power_up(self,color : int) -> int:
        quantity = 0
        for i in range(8):
            for j in range(8):
                if self.tiles[i][j].color == color:
                    self.tiles[i][j] = None
                    quantity += 1
        return quantity

    def get_falling_tiles(self) -> Tuple[Any, Dict[str, Any]]:
        # List of tweens to create
        tweens: Tuple[Tile, Dict[str, Any]] = []

        # for each column, go up tile by tile until we hit a space
        for j in range(settings.BOARD_WIDTH):
            space = False
            space_i = -1
            i = settings.BOARD_HEIGHT - 1

            while i >= 0:
                tile = self.tiles[i][j]

                # if our previous tile was a space
                if space:
                    # if the current tile is not a space
                    if tile is not None:
                        self.tiles[space_i][j] = tile
                        tile.i = space_i

                        # set its prior position to None
                        self.tiles[i][j] = None

                        tweens.append((tile, {"y": tile.i * settings.TILE_SIZE}))
                        space = False
                        i = space_i
                        space_i = -1
                elif tile is None:
                    space = True

                    if space_i == -1:
                        space_i = i

                i -= 1

        # create a replacement tiles at the top of the screen
        for j in range(settings.BOARD_WIDTH):
            for i in range(settings.BOARD_HEIGHT):
                tile = self.tiles[i][j]

                if tile is None:
                    tile = Tile(
                        i,
                        j,
                        random.randint(0, settings.NUM_COLORS - 1),
                        random.randint(0, settings.NUM_VARIETIES - 1),
                    )
                    tile.y -= settings.TILE_SIZE
                    self.tiles[i][j] = tile
                    tweens.append((tile, {"y": tile.i * settings.TILE_SIZE}))

        return tweens

    def WillThereBeAMatch(self, tile, i,j):

        same_color = [False,False]
        h_match = []
        v_match = []
        h_min_max = [max(0,j-2),min(7, j + 2)]
        v_min_max = [max(0,i-2),min(7, i + 2)]

        self.swap_tiles(i,j,tile.i,tile.j)

        while h_min_max[0] <= h_min_max[1]:
            h_match.append(self.tiles[i][h_min_max[0]])
            h_min_max[0] += 1

        h = 0
        in_row = 0
        color_index = []
        while h in range(len(h_match)):
            if h_match[h].color == tile.color:
                color_index.append(h)
                in_row += 1
            else:
                in_row = 0
                color_index.clear()
            h += 1
            if in_row >= 3:
                same_color[0] = True
                break

        g = 0
        if len(color_index) >= 3:
            while g < len(color_index):
                h_match[color_index[g]].can_match = True
                g += 1


        #now vertically

        while v_min_max[0] <= v_min_max[-1]:
            v_match.append(self.tiles[v_min_max[0]][j])
            v_min_max[0] += 1

        color_index.clear()

        v = 0
        in_row = 0
        while v in range(len(v_match)):
            if v_match[v].color == tile.color:
                in_row += 1
                color_index.append(v)
            else:
                in_row = 0
                color_index.clear()
            v += 1
            if in_row >= 3:
                same_color[1] = True
                break

        g = 0
        if len(color_index) >= 3:
            while g < len(color_index):
                v_match[color_index[g]].can_match = True
                g += 1

        self.swap_tiles(i,j,tile.i,tile.j)

        return any(same_color)

    def CanMove(self, tile, i,j)-> bool:
        #tile is original tile, and i,j are coord to move that tile
        if j < 0 or j >= 8 or i < 0 or i >= 8:
            return False

        return self.WillThereBeAMatch(tile,i,j) or self.WillThereBeAMatch(self.tiles[i][j],tile.i,tile.j)

    def ExistMatch(self):
        for i in range(8):
            for j in range(8):
                tile = self.tiles[i][j]
                if tile.variety >= 7:
                    return True
        for i in range(7):
            for j in range(7):
                tile = self.tiles[i][j]
                if self.CanMove(tile, i - 1, j) or self.CanMove(tile, i + 1, j) or self.CanMove(tile, i, j - 1) or self.CanMove(tile, i, j + 1):
                    return True
        return False

    def swap_tiles(self,i1,j1,i2,j2):
        (
            self.tiles[i1][j1],
            self.tiles[i2][j2],
        ) = (
            self.tiles[i2][j2],
            self.tiles[i1][j1],
        )

    def MarkMatches(self):
        for i in range(8):
            for j in range(8):
                self.tiles[i][j].can_match = False
        for i in range(7):
            for j in range(7):
                tile = self.tiles[i][j]
                self.CanMove(tile, i - 1, j)
                self.CanMove(tile, i + 1, j)
                self.CanMove(tile, i, j - 1)
                self.CanMove(tile, i, j + 1)
