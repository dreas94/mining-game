class_name Item
extends RefCounted


var id: String = "none"
var item_attributes: ItemAttributes
var item_instance: ItemInstance: get = get_item_instance
var item_visuals: ItemVisuals


func get_item_instance() -> ItemInstance:
	if is_instance_valid(item_instance):
		return item_instance
	
	# Intentionally not kept, and not preloaded
	item_instance = ItemInstance.new(item_attributes)
	item_instance.item_ref = weakref(self)
	item_visuals = item_instance.item_visuals
	
	return item_instance


func _init(_item_template: ItemTemplate) -> void:
	id = _item_template.get_file_name()
	
	item_attributes = ItemAttributes.new(_item_template)
