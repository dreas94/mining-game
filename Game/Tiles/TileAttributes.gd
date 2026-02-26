class_name TileAttributes
extends RefCounted

# Static
var template: TileTemplate
var name: String = "unnamed tile"
var item_template: ItemTemplate
var amount_range: Vector2i = Vector2i.ZERO
var atlas_coords: Vector2i = Vector2i.ZERO

# Values
var health: IntAttribute = IntAttribute.new(0)
var is_moused: BoolAttribute = BoolAttribute.new(false)


func _init(_tile_template: TileTemplate) -> void:
	template = _tile_template
	name = _tile_template.tile_name
	item_template = _tile_template.item_dropped
	amount_range = _tile_template.amount_range
	atlas_coords = _tile_template.atlas_coords
	health.set_value_silent(_tile_template.health)
	health.set_maximum_silent(_tile_template.health)
	
