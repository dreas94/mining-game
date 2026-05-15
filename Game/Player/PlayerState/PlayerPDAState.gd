class_name PlayerPDAState
extends PushDownAutomataState

func physics_process(delta: float) -> void:
	_update_movement(delta)
	pda.owner.move_and_slide()


func _update_movement(delta: float) -> void:
	#Gravity
	if pda.owner.is_on_floor():
		return
	
	pda.owner.velocity.y += pda.owner.gravity * delta
