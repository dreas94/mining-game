extends Node2D
@export var map_size: Vector2i = Vector2i(110, 60)
@export var world_seed: String = "4_20_69"
@export var fractal_octaves: int = 4
@export var fractal_gain: float = 0.5
@export var fractal_lacunarity: float = 1
@export var noise_threshold: float = 0.1
@export var fractal_weighted_strength: float = 0.1
@export var frequency: float = 0.1

var stone_template: BlockTemplate = load("res://Content/BlockTemplates/Stone.tres")
var simplex_noise: FastNoiseLite = FastNoiseLite.new()

var map: Array[Vector2i]
var world_ref: WeakRef

func _ready():
	generate()


func generate():
	self.simplex_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	self.simplex_noise.seed = self.world_seed.hash()
	self.simplex_noise.fractal_octaves = self.fractal_octaves
	self.simplex_noise.fractal_gain = self.fractal_gain
	self.simplex_noise.fractal_lacunarity = self.fractal_lacunarity
	self.simplex_noise.fractal_weighted_strength = self.fractal_weighted_strength
	self.simplex_noise.frequency = self.frequency
	
	var player: iPlayer = get_parent().player
	map.append(Vector2i(0, 0))
	for x in range(-self.map_size.x / 2.0, self.map_size.x / 2.0):
		for y in range(-self.map_size.y / 2.0, self.map_size.y / 2.0):
			if self.simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				var pos: Vector2 = BlockConstants.SIZE * Vector2(x, y)
				if player.global_position.distance_to(pos) > BlockConstants.SIZE.x * 2:
					map.append(Vector2i(x, y))
	
	_set_autotile()

func _set_autotile():
	for vec2: Vector2i in map:
		var block: Block = Block.new(stone_template)
		var block_instance: BlockInstance = block.get_block_instance()
		block_instance.position = Vector2(BlockConstants.SIZE.x * vec2.x, BlockConstants.SIZE.y * vec2.y)
		add_child(block_instance)
