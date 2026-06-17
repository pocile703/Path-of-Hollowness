extends RefCounted
class_name TutorialLayout

## Plain data describing a tutorial level. Built in code by TutorialLayouts and
## consumed by tutorial_level.gd. Collections are untyped to avoid typed-array
## assignment friction; element types are noted in comments. Tile coords are
## 16px units; world fields are pixels.

var level_title: String = ""

var spawn: Vector2 = Vector2.ZERO   # player start (world); first checkpoint auto-placed here

# Geometry. fill_rect = one big solid block (cave), carve_rects cut tunnels;
# solid_rects = extra additive solid blocks (platforms). All unioned then carved.
var fill_rect: Rect2i = Rect2i(0, 0, 0, 0)   # tiles; zero size = unused
var carve_rects: Array = []                   # of Rect2i (tiles) carved OUT of fill
var solid_rects: Array = []                   # of Rect2i (tiles) added solid

# Upward spikes: world-pixel CENTER of each 32x32 spike sprite.
var spikes: Array = []

# Moving chainsaws. Each entry is a Dictionary:
#   { "pos": Vector2(world), "big": bool, "points": [Vector2 relative...],
#     "speed_scale": float, "loop": bool, "speed": float }
var saws: Array = []

var checkpoints: Array = []   # of Vector2 (world), in addition to spawn
var hints: Array = []         # of { "rect": Rect2(world), "text": String }

var exit_pos: Vector2 = Vector2.ZERO   # world; place at the ground surface (door sits on it)
var next_scene: String = ""

var cam_bounds: Rect2 = Rect2(0, 0, 960, 320)   # camera clamp (world)
var kill_y: float = 100000.0                     # fall-death plane (world y)
