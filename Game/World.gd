extends Node2D
const ADJ_VECS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]

@export var player: iPlayer
@export var tile_map: TileMapLayer
var custom_cell_data: Dictionary = {}


func _ready() -> void:
	player.global_position.y = -tile_map.rendering_quadrant_size
	player.mine_attempt.connect(_attempt_to_clear_cell_from_position)
	for cell: Vector2i in tile_map.get_used_cells():
		if not tile_map.get_cell_tile_data(cell).has_custom_data("Health"):
			continue
		custom_cell_data[cell] = tile_map.get_cell_tile_data(cell).get_custom_data("Health")


func _attempt_to_clear_cell_from_position(damage: int):
	var pos: Vector2 = tile_map.get_local_mouse_position()
	var cell: Vector2i = tile_map.local_to_map(pos)
	var player_cell: Vector2i = tile_map.local_to_map(player.position)
	var coordinate_difference: Vector2i = abs(player_cell - cell)
	
	if cell == null:
		return
	
	if coordinate_difference.x > 1:
		return
	
	if coordinate_difference.y > 1:
		return
	
	var cells_to_update: Array[Vector2i] = []
	var tile_data: TileData = tile_map.get_cell_tile_data(cell)
	
	if tile_data == null:
		return
	
	if tile_data.terrain != 0:
		return
	
	if custom_cell_data[cell] == null:
		return
	
	custom_cell_data[cell] -= damage
	
	var health: int = custom_cell_data[cell]
	
	if health > 0:
		return
	
	tile_map.set_cell(cell, -1)
	
	for neb_cell: Vector2i in ADJ_VECS:
		var cell_to_check: Vector2i = cell + neb_cell
		if tile_map.get_cell_tile_data(cell_to_check) == null:
			continue
		
		cells_to_update.append(cell_to_check)
	
	tile_map.set_cells_terrain_connect([cell], 0, -1, true)
