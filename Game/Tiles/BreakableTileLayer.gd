class_name BreakableTileMapLayer
extends TileMapLayer

const ADJ_VECS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]

@export var over_layer: TileMapLayer

var _breakable_tile_visual_scene: PackedScene = load("uid://2cdd1ob0n0k6")
var _cells_array: Array[Vector2i]
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
		active_items.append(Item.new(_custom_cell_data[cell].item_template))
		var instance: ItemInstance = active_items.back().get_item_instance()
		instance.set_position(map_to_local(cell))
		World.add_child(active_items.back().get_item_instance())
		over_layer.set_cell(cell)
	
	_custom_cell_data.erase(cell)
	set_cells_terrain_connect([cell], 0, -1, true)
