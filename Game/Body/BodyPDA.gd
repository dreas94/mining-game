class_name BodyPDA
extends PushDownAutomataStateMachine

func _init(body: Body) -> void:
	owner = body


func physics_update(delta: float) -> void:
	_physics_update(delta)
