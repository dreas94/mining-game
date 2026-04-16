class_name BreakableTileMapLayer
extends TileMapLayer

const ADJ_VECS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]

#var _active_lights: Dictionary = {}
var active_items: Array[Item]
var hovered


func create_cell_data(cell: Vector2i, template: TileTemplate) -> void:
	var tile: Tile = Mines.tile_handler.instance_template_to_grid_position(template, cell, to_global(map_to_local(cell)))
	if tile.tile_attributes.item_template == null:
		set_cells_terrain_connect([cell], 0, 0)
	else:
		set_cells_terrain_connect([cell], 0, 0)


func translate_to_grid_positon(global_pos: Vector2) -> Vector2i:
	var local_pos: Vector2 = to_local(global_pos)
	var grid_position: Vector2i = local_to_map(local_pos)
	return grid_position


func is_target_position_close_enough_to_player(player_cell: Vector2i, target_cell: Vector2i) -> bool:
	var distance: Vector2i = abs(player_cell - target_cell)
	
	if distance.x > 1.0:
		return false
	
	if distance.y > 1:
		return false
	
	return true
	


func attempt_to_clear_cell(damage: int, rid: RID, player_position: Vector2):
	var player_cell: Vector2i = local_to_map(player_position)
	var cell: Vector2i
	
	if rid == null:
		return
	
	cell = get_coords_for_body_rid(rid)
	
	if cell == null:
		return
	
	if not is_target_position_close_enough_to_player(player_cell, cell):
		return
	
	if Mines.tile_handler.has_tile_at_grid_position(cell) == false:
		return
	
	var tile: Tile = Mines.tile_handler.get_tile_in_grid_position(cell)
	
	tile.tile_attributes.health.value -= damage


func clear_cell_at_global_position(global_pos: Vector2) -> void:
	var cell: Vector2i = Mines.breakable_tile_map_layer.local_to_map(to_local(global_pos))
	Mines.breakable_tile_map_layer.set_cells_terrain_connect([cell], 0, -1, true)
	update_internals()


func clear_tilemaps() -> void:
	clear()
