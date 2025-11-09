class_name Block
extends RefCounted

var id: String = "none"
var template: BlockTemplate
var attributes: BlockAttributes
var block_instance: BlockInstance: get = get_block_instance
var visuals: BlockVisuals


func get_block_instance() -> BlockInstance:
	if is_instance_valid(block_instance):
		return block_instance
	
	# Intentionally not kept, and not preloaded
	block_instance = BlockInstance.new(attributes, template)
	block_instance.block_ref = weakref(self)
	visuals = block_instance.visuals
	
	return block_instance


func _init(_template: BlockTemplate) -> void:
	id = _template.get_file_name()
	
	template = _template
	attributes = BlockAttributes.new(template)


func has_block_instance() -> bool:
	return is_instance_valid(block_instance)


func has_visual_instance() -> bool:
	return is_instance_valid(visuals)
