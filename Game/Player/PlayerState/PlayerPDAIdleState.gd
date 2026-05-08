class_name PlayerPDAIdleState
extends PushDownAutomataState


func on_state_pushed() -> void:
	pda.owner.animation_player.play("Idle")


func on_state_reactivated() -> void:
	pda.owner.animation_player.play("Idle")
