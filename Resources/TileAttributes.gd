class_name TileAttributes
extends RefCounted

# Values
var id: int
var health: IntAttribute = IntAttribute.new(0)


func _init(_id: int, _health: int) -> void:
	id = _id
	health.set_value_silent(_health)
