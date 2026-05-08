class_name PlayerPDAWalkState
extends PushDownAutomataState


func on_state_pushed() -> void:


func on_state_reactivated() -> void:
	pda.owner.animation_player.play("Walk")
