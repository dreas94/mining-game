class_name BreakableTileMapLayer
extends TileMapLayer

const ADJ_VECS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]

@export var over_layer: TileMapLayer
#var _active_lights: Dictionary = {}
var active_items: Array[Item]


func create_cell_data(cell: Vector2i, template: TileTemplate) -> void:
	var tile: Tile = World.tile_handler.instance_template_to_grid_position(template, cell, to_global(map_to_local(cell)))
	if tile.tile_attributes.item_template == null:
		set_cells_terrain_connect([cell], 0, 0)
	else:
		set_cells_terrain_connect([cell], 0, 0)
		over_layer.set_cell(cell, 0, tile.tile_attributes.atlas_coords)
		#var light_source: AnimatedPointLight2D = load("uid://dsr0f5ealpe4e").instantiate()
		#light_source.global_position = to_global(map_to_local(cell))
		#light_source.base_energy = 0.25
		#light_source.base_scale = 0.25
		#light_source.duration_per_scale_update = 1.0
		#light_source.color = Color(0.762, 0.321, 0.0)
		#World.add_child(light_source)
		#_active_lights[cell] = light_source


func _physics_process(_delta: float) -> void:
	var global_mouse_pos: Vector2 = get_global_mouse_position()
	var local_mouse_pos: Vector2 = to_local(global_mouse_pos)
	var tile_pos: Vector2i = local_to_map(local_mouse_pos)
	
	#if World.tile_handler.has_tile_at_grid_position(tile_pos) != false:
		#var tile: Tile = World.tile_handler.get_tile_in_grid_position(tile_pos)
		#tile.tile_attributes.is_moused.value = true


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
	
	if World.tile_handler.has_tile_at_grid_position(cell) == false:
		return
	
	var tile: Tile = World.tile_handler.get_tile_in_grid_position(cell)
	
	tile.tile_attributes.health.value -= damage


func clear_cell_at_global_position(global_pos: Vector2) -> void:
	var cell: Vector2i = World.breakable_tile_map_layer.local_to_map(to_local(global_pos))
	World.breakable_tile_map_layer.set_cells_terrain_connect([cell], 0, -1, true)
