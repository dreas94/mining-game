class_name BlockInstance
extends Node2D

var block_ref: WeakRef
var attributes: BlockAttributes
var visuals: BlockVisuals

var visuals_scene: PackedScene = load("uid://dap5886bhjbq5")

var _impact_region: ImpactRegion

func _init(_attributes: BlockAttributes, _template: BlockTemplate) -> void:
	attributes = _attributes
	name = attributes.name
	
	visuals = visuals_scene.instantiate()
	
	add_child(visuals)
	visuals.attributes = _attributes
	
	add_to_group(BlockConstants.BLOCK_INSTANCE_GROUP)
	
	_impact_region = ImpactRegion.new(BlockConstants.SIZE)
	add_child(_impact_region)
