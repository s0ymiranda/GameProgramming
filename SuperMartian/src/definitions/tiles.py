"""
ISPPJ1 2023
Study Case: Super Martian (Platformer)

Author: Alejandro Mujica
alejandro.j.mujic4@gmail.com

This file contains the definition for tiles.
"""
from typing import Dict, Any

TILES: Dict[int, Dict[str, Any]] = {
    # Ground
    0: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    1: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    2: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    3: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    4: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    5: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    10: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    77: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    78: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    79: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    80: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    81: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    82: {"solidness": dict(top=True, right=False, bottom=False, left=False)},
    87: {"solidness": dict(top=True, right=False, bottom=False, left=False)},


    # Blocks
    6: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    17: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    41: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    76: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    83: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    104: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    111: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    119: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    120: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    121: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
    126: {"solidness": dict(top=True, right=True, bottom=True, left=True)},
}
