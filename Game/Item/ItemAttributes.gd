class_name ItemAttributes
extends RefCounted

# Static
var template: ItemTemplate
var name: String = "unnamed card"

# Values
var graphic: Texture2DAttribute = Texture2DAttribute.new(preload("res://Textures/2.png"))


func _init(_item_template: ItemTemplate) -> void:
	template = _item_template
	name = _item_template.item_name
	graphic.set_silent(_item_template.item_graphic)
