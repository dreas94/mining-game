class_name BodyPartPDA
extends PushDownAutomataStateMachine

func _init(body_part: BodyPartArms) -> void:
	owner = body_part


func physics_update(delta: float) -> void:
	_physics_update(delta)
