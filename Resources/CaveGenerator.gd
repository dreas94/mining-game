extends Node2D
@export var map_width: int = 80
@export var map_height: int = 50
@export var map_size: Vector2i = Vector2i(110, 60)
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

func _ready():
	self.tile_map = get_parent() as TileMapLayer
	generate()


func generate():
	self.simplex_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	self.simplex_noise.seed = self.world_seed.hash()
	self.simplex_noise.fractal_octaves = self.fractal_octaves
	self.simplex_noise.fractal_gain = self.fractal_gain
	self.simplex_noise.fractal_lacunarity = self.fractal_lacunarity
	self.simplex_noise.fractal_weighted_strength = self.fractal_weighted_strength
	self.simplex_noise.frequency = self.frequency
	

	for x in range(-self.map_width / 2.0, self.map_width / 2.0):
		for y in range(-self.map_height / 2.0, self.map_height / 2.0):
			var noise_val: float = simplex_noise.get_noise_2d(x, y)
			
			noise_val_array.append(noise_val)
			
			if noise_val < self.noise_threshold:
				space_tiles_array.append(Vector2i(x,y))
			
		tile_map.set_cells_terrain_connect(space_tiles_array, 0, 0)
