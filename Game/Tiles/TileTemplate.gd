class_name TileTemplate
extends Resource


@export_category("Info")
@export var tile_name: String = "Name this tile"

@export_category("Values")
@export var health: int = 0

@export_category("Drops")
@export var item_dropped: ItemTemplate
@export var amount_range: Vector2i = Vector2i.ZERO

@export_category("Tiles")
@export var atlas_coords: Vector2i = Vector2i.ZERO


func get_file_name() -> String:
	return resource_path.get_file().get_basename()


func get_item_id() -> String:
	return get_file_name()
