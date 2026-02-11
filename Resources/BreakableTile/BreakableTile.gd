class_name BreakableTile
extends Node2D

var size: Vector2
var visual: ColorRect = ColorRect.new()
var health: IntAttribute = IntAttribute.new(100, 100)

func _init(tile_size: Vector2, global_pos: Vector2) -> void:
	size = tile_size
	global_position = global_pos
	


func _ready() -> void:
	health.changed.connect(_on_health_changed)
	add_child(visual)
	visual.size = size
	visual.position = Vector2(-size.x * 0.5, -size.x * 0.5)
	visual.color = Color(0.0, 0.0, 0.0, 0.0)


func _on_health_changed(value: int, _delta: int) -> void:
	visual.color.a = value * 0.01
