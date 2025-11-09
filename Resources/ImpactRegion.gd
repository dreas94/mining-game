@tool
class_name ImpactRegion
extends Node2D

@export var size: Vector2 = BlockConstants.SIZE:
	set(value):
		value = value.abs()
		size = value
		_effective_size = size * size_scale
		queue_redraw()

@export var size_scale: Vector2 = Vector2(1, 1):
	set(value):
		value = value.abs()
		size_scale = value
		_effective_size = size * size_scale
		queue_redraw()

var _body: StaticBody2D
var _collision_shape: CollisionShape2D
var _effective_size: Vector2 = size * size_scale


func _init(_size: Vector2 = Vector2.ZERO) -> void:
	if _size != Vector2.ZERO:
		size = _size
	
	_body = StaticBody2D.new()
	var phys_material: PhysicsMaterial = PhysicsMaterial.new()
	_body.physics_material_override = phys_material
	add_child(_body)
	
	_collision_shape = CollisionShape2D.new()
	
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.set_size(_size)
	_collision_shape.shape = shape
	
	_body.add_child(_collision_shape)
