class_name BreakableTileMapLayer
extends TileMapLayer

const ADJ_VECS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]

var _breakable_tile_visual_scene: PackedScene = load("uid://2cdd1ob0n0k6")
var _cells_array: Array[Vector2i]
var _custom_cell_data: Dictionary = {}


func get_cells_array() -> Array[Vector2i]:
	return _cells_array.duplicate()


func create_cell_data(cell: Vector2i, id: int, health: int) -> void:
	_cells_array.append(cell)
	_custom_cell_data[cell] = TileAttributes.new(id, health)
	_custom_cell_data[cell].health.changed.connect(_on_health_changed.bind(cell))


func attempt_to_clear_cell_from_position(damage: int, rid: RID, player_position: Vector2):
	var cell: Vector2i = get_coords_for_body_rid(rid)
	var player_cell: Vector2i = local_to_map(player_position)
	var coordinate_difference: Vector2i = abs(player_cell - cell)
	
	if cell == null:
		return
	
	if coordinate_difference.x > 1:
		return
	
	if coordinate_difference.y > 1:
		return
	
	if _custom_cell_data.get(cell) != null and _custom_cell_data.get(cell).health.value == 100:
		var global_position_of_tile = to_global(map_to_local(cell))
		var breakable_tile_visual: BreakableTileVisuals = _breakable_tile_visual_scene.instantiate()
		breakable_tile_visual.tile_attributes = _custom_cell_data.get(cell)
		breakable_tile_visual.global_position = global_position_of_tile
		World.add_child(breakable_tile_visual)
	
	_custom_cell_data[cell].health.value -= damage


func _on_health_changed(value: int, _delta: int, cell: Vector2i) -> void:
	App.sfx.play(DefaultSoundEffects.PICKAXE)
	if value > 0:
		return
	
	_custom_cell_data.erase(cell)
	set_cells_terrain_connect([cell], 0, -1, true)
