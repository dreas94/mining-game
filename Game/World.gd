extends Node2D
const ADJ_VECS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]

@export var player: iPlayer
@export var tilemap: TileMapLayer

func _ready() -> void:
	player.global_position.y = -BlockConstants.SIZE.y
	player.mine_attempt.connect(_attempt_to_clear_cell_from_position)


func _attempt_to_clear_cell_from_position():
	var pos: Vector2 = tilemap.get_local_mouse_position()
	var cell: Vector2i = tilemap.local_to_map(pos)
	var player_cell: Vector2i = tilemap.local_to_map(player.position)
	var coordinate_difference: Vector2i = abs(player_cell - cell)
	
	if cell == null:
		print("No Cell Found at ", pos)
		return
	
	if coordinate_difference.x > 1:
		print("Cell too far away ", cell)
		return
	
	if coordinate_difference.y > 1:
		print("Cell too far away ", cell)
		return
	
	var cells_to_update: Array[Vector2i] = []
	print("Cell found ", cell)
	var tile_data_before: TileData = tilemap.get_cell_tile_data(cell)
	print(tile_data_before)
	tilemap.set_cell(cell, -1)
	var tile_data_after: TileData = tilemap.get_cell_tile_data(cell)
	print(tile_data_after)
	print(tilemap.get_surrounding_cells(cell))
	
	for neb_cell: Vector2i in ADJ_VECS:
		var cell_to_check: Vector2i = cell + neb_cell
		if tilemap.get_cell_tile_data(cell_to_check) == null:
			continue
		
		cells_to_update.append(cell_to_check)
	
	print(cells_to_update)
	
	tilemap.set_cells_terrain_connect([cell], 0, -1, true)
