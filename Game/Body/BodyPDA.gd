class_name BodyPDA
extends PushDownAutomataStateMachine

func _init(body: iBody) -> void:
	owner = body


func physics_update(delta: float) -> void:
	_physics_update(delta)
