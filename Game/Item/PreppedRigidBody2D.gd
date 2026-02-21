class_name PreppedRigidBody2D
extends RigidBody2D

var collision_shape: CollisionShape2D


func _init(_size: Vector2) -> void:
	collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = _size
	contact_monitor = true
	max_contacts_reported = 1
	can_sleep = false
	collision_layer = 32
	collision_mask = 33
	add_child(collision_shape)
	
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	print("Rigid Body Colission")
	if not body.is_in_group("Player"):
		return
