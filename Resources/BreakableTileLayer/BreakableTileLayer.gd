class_name BreakableTileMapLayer
extends TileMapLayer

const ADJ_VECS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]

var _custom_cell_data: Dictionary = {}


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
	
	var tile_data: TileData = get_cell_tile_data(cell)
	
	if tile_data == null:
		return
	
	var breakable_tile: BreakableTile = null
	if _custom_cell_data.get(cell) == null:
		var global_position_of_tile = to_global(map_to_local(cell))
		_custom_cell_data[cell] = BreakableTile.new(tile_set.tile_size, global_position_of_tile)
		add_child(_custom_cell_data[cell])
	
	breakable_tile = _custom_cell_data[cell]
	breakable_tile.health.value -= damage
	
	App.sfx.play(DefaultSoundEffects.PICKAXE)
	
	if breakable_tile.health.value > 0.0:
		return
	
	_custom_cell_data.erase(cell)
	breakable_tile.queue_free()
	set_cells_terrain_connect([cell], 0, -1, true)
