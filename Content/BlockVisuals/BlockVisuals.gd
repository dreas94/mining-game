class_name BlockVisuals
extends Node2D

@export var color_rect: ColorRect

var _block_attributes: BlockAttributes


func _ready() -> void:
	_block_attributes.color.changed.connect(_on_color_changed)
	_block_attributes.durability.changed.connect(_on_durability_changed)


func _on_color_changed(new_value: Color, _previous_value: Color) -> void:
	color_rect.modulate = new_value


func _on_durability_changed(int_value: int, _int_delta: int) -> void:
	var remapped_value: float = remap(int_value, 0, _block_attributes.durability.maximum, 0.0, 1.0)
	set_deferred("shader_parameter/crack_alpha", remapped_value)
