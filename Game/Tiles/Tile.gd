class_name Tile
extends RefCounted

var id: String = "none"
var tile_attributes: TileAttributes
var tile_instance: TileInstance: get = get_tile_instance
var tile_visuals: TileVisuals
var _tile_handler: TileHandler


func get_tile_instance() -> TileInstance:
	if is_instance_valid(tile_instance):
		return tile_instance
	
	# Intentionally not kept, and not preloaded
	tile_instance = TileInstance.new(tile_attributes)
	tile_instance.tile_ref = weakref(self)
	tile_visuals = tile_instance.tile_visuals
	
	return tile_instance


func _init(_tile_template: TileTemplate) -> void:
	id = _tile_template.get_file_name()
	
	tile_attributes = TileAttributes.new(_tile_template)


func set_tile_to_handler(handler: TileHandler) -> void:
	_tile_handler = handler
