class_name BlockAttributes
extends RefCounted

# Static
var template: BlockTemplate
var name: String

# Values
var color: AnyAttribute
var durability: IntAttribute


func _init(block_template: BlockTemplate) -> void:
	template = block_template
	name = template.name
	color.set_value_silent(template.color)
	@warning_ignore("narrowing_conversion")
	durability.set_value_silent(template.durability.x)
	@warning_ignore("narrowing_conversion")
	durability.set_maximum_silent(template.durability.y)
