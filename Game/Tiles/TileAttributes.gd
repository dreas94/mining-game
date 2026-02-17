class_name TileAttributes
extends RefCounted

# Static
var template: TileTemplate
var name: String = "unnamed tile"

# Values
var health: IntAttribute = IntAttribute.new(0)


func _init(_tile_template: TileTemplate) -> void:
	template = _tile_template
	name = _tile_template.tile_name
	health.set_value_silent(_tile_template.health)
