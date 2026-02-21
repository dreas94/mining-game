class_name BreakableTileMapLayer
extends TileMapLayer

const ADJ_VECS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]

@export var over_layer: TileMapLayer

var _breakable_tile_visual_scene: PackedScene = load("uid://2cdd1ob0n0k6")
var _cells_array: Array[Vector2i]
#var _active_lights: Dictionary = {}
var active_items: Array[Item]
var _custom_cell_data: Dictionary = {}


func create_cell_data(cell: Vector2i, template: TileTemplate) -> void:
	_cells_array.append(cell)
	_custom_cell_data[cell] = TileAttributes.new(template)
	_custom_cell_data[cell].health.changed.connect(_on_health_changed.bind(cell))
	if _custom_cell_data[cell].item_template == null:
		set_cells_terrain_connect([cell], 0, 0)
	else:
		set_cells_terrain_connect([cell], 0, 0)
		over_layer.set_cell(cell, 0, _custom_cell_data[cell].atlas_coords)
		#var light_source: AnimatedPointLight2D = load("uid://dsr0f5ealpe4e").instantiate()
		#light_source.global_position = to_global(map_to_local(cell))
		#light_source.base_energy = 0.25
		#light_source.base_scale = 0.25
		#light_source.duration_per_scale_update = 1.0
		#light_source.color = Color(0.762, 0.321, 0.0)
		#World.add_child(light_source)
		#_active_lights[cell] = light_source


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
	
	if rid != null:
		cell = get_coords_for_body_rid(rid)
	
	if cell == null:
		return
	
	if not is_target_position_close_enough_to_player(player_cell, cell):
		return
	
	if _custom_cell_data.has(cell) == false:
		return
	
	if  _custom_cell_data.get(cell).health.value == _custom_cell_data.get(cell).health.maximum:
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
	
	if _custom_cell_data[cell].item_template != null:
		for index: int in randi_range(_custom_cell_data[cell].amount_range.x, _custom_cell_data[cell].amount_range.y):
			active_items.append(Item.new(_custom_cell_data[cell].item_template))
			var instance: ItemInstance = active_items.back().get_item_instance()
			instance.set_position(map_to_local(cell))
			World.add_child(active_items.back().get_item_instance())
			over_layer.set_cell(cell)
		#var light_source: AnimatedPointLight2D = _active_lights[cell]
		#light_source.queue_free()
		#_active_lights.erase(cell)
	
	_custom_cell_data.erase(cell)
	set_cells_terrain_connect([cell], 0, -1, true)
