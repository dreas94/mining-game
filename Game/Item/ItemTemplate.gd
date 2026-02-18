class_name ItemTemplate
extends Resource

@export_category("Info")
@export var item_name: String = "Name this item"

@export_category("Visuals")
@export var item_graphic: Texture2D


func get_file_name() -> String:
	return resource_path.get_file().get_basename()


func get_item_id() -> String:
	return get_file_name()
