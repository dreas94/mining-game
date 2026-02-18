class_name TileAttributes
extends RefCounted

# Static
var template: TileTemplate
var name: String = "unnamed tile"
var item_template: ItemTemplate
var amount_range: Vector2i = Vector2i.ZERO

# Values
var health: IntAttribute = IntAttribute.new(0)


func _init(_tile_template: TileTemplate) -> void:
	template = _tile_template
	name = _tile_template.tile_name
	item_template = _tile_template.item_dropped
	amount_range = _tile_template.amount_range
	health.set_value_silent(_tile_template.health)
	
