class_name CaveGenerator
extends Node
@export var map_width: int = 80
@export var map_height: int = 80
@export var world_seed: String = "4_20_69"
@export var fractal_octaves: int = 4
@export var fractal_gain: float = 0.5
@export var fractal_lacunarity: float = 1
@export var noise_threshold: float = 0.1
@export var fractal_weighted_strength: float = 0.1
@export var frequency: float = 0.1

var tile_map : TileMapLayer
var simplex_noise: FastNoiseLite = FastNoiseLite.new()

var map: Array[Vector2i]
var world_ref: WeakRef
var noise_val_array: Array[float]
var space_tiles_array: Array[Vector2i]


func generate(new_tile_map: TileMapLayer):
	self.tile_map = new_tile_map
	self.simplex_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	self.simplex_noise.seed = self.world_seed.hash()
	self.simplex_noise.fractal_octaves = self.fractal_octaves
	self.simplex_noise.fractal_gain = self.fractal_gain
	self.simplex_noise.fractal_lacunarity = self.fractal_lacunarity
	self.simplex_noise.fractal_weighted_strength = self.fractal_weighted_strength
	self.simplex_noise.frequency = self.frequency
	
	var min_width: int = floor(-(self.map_width + 2) / 2.0)
	var max_width: int = floor((self.map_width + 2) / 2.0)
	var min_height: int = floor(-(self.map_width + 2) / 2.0)
	var max_height: int = floor((self.map_width + 2) / 2.0)
	for x in range(min_width, max_width):
		for y in range(min_height, max_height):
			if x in range(min_width, min_width + 2) or x in range(max_width - 2, max_width):
				space_tiles_array.append(Vector2i(x,y))
			elif y in range(min_height, min_height + 2) or y in range(max_height - 2, max_height):
				space_tiles_array.append(Vector2i(x,y))
			elif (not x in range(0, 2)) or (not y in range(-2, 0)):
				var noise_val: float = simplex_noise.get_noise_2d(x, y)
				if noise_val < self.noise_threshold:
					space_tiles_array.append(Vector2i(x,y))
	
	tile_map.set_cells_terrain_connect(space_tiles_array, 0, 0)
	#tile_map.set_cells_terrain_connect(empty_tiles_array, 0, 1, false)
