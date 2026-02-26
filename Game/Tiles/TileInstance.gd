class_name TileInstance
extends Node2D

var tile_visuals_scene: PackedScene = load("uid://2cdd1ob0n0k6")

var tile_ref: WeakRef
var tile_attributes: TileAttributes
var tile_visuals: TileVisuals


func _init(_tile_attributes: TileAttributes) -> void:
	tile_attributes = _tile_attributes
	
	tile_visuals = tile_visuals_scene.instantiate()
	tile_visuals.tile_attributes = tile_attributes
	add_child(tile_visuals)
	
	tile_attributes.health.changed.connect(_on_health_changed)


func _on_health_changed(value: int, _delta: int) -> void:
	App.sfx.play(DefaultSoundEffects.PICKAXE)
	if value > 0:
		return
	
	var cell: Vector2i = World.breakable_tile_map_layer.local_to_map(global_position)
	if tile_attributes.item_template != null:
		for index: int in randi_range(tile_attributes.amount_range.x, tile_attributes.amount_range.y):
			World.breakable_tile_map_layer.active_items.append(Item.new(tile_attributes.item_template))
			var instance: ItemInstance = World.breakable_tile_map_layer.active_items.back().get_item_instance()
			instance.set_position(global_position)
			World.add_child(World.breakable_tile_map_layer.active_items.back().get_item_instance())
			World.breakable_tile_map_layer.over_layer.set_cell(cell)
	World.tile_handler.remove_tile_from_handler(tile_ref.get_ref())
	World.breakable_tile_map_layer.set_cells_terrain_connect([cell], 0, -1, true)
