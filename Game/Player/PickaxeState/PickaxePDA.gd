class_name PickaxePDA
extends PushDownAutomataStateMachine

func _init(player: iPlayer) -> void:
	owner = player


func physics_update(delta: float) -> void:
	_physics_update(delta)
