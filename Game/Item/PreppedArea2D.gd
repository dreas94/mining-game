class_name PreppedArea2D
extends Area2D

var collision_shape: CollisionShape2D


func _init(_size: Vector2) -> void:
	collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = _size
	add_child(collision_shape)
