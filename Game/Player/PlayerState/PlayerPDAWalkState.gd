class_name PlayerPDAWalkState
extends PushDownAutomataState


func on_state_pushed() -> void:
	if pda.owner.move_direction > 0.0:
		pda.owner.character_sprite.scale = Vector2(1.0, 1.0)
	elif pda.owner.move_direction < 0.0:
		pda.owner.character_sprite.scale = Vector2(-1.0, 1.0)


func on_state_reactivated() -> void:
	pda.owner.animation_player.play("Walk")
