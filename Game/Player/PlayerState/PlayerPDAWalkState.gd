class_name PlayerPDAWalkState
extends PlayerPDAState


func on_state_pushed() -> void:
	pda.owner.animation_player.play("Walk")


func on_state_reactivated() -> void:
	pda.owner.animation_player.play("Walk")


func physics_process(delta: float) -> void:
	var move_direction: float = pda.owner.move_direction
	if move_direction > 0.0:
		pda.owner.character_sprite.scale = Vector2(1.0, 1.0)
	elif move_direction < 0.0:
		pda.owner.character_sprite.scale = Vector2(-1.0, 1.0)
	
	
	if Game.state.active_state is GameStateMines:
		Health.sub_health(1.0 * delta)
	
	if Input.is_action_pressed("jump") and pda.owner.is_on_floor():
		pda.push_state_to_stack(PlayerPDAJumpState.new())
	
	if move_direction == 0:
		pop_state_from_stack()
	
	var velocity_x: float = pda.owner.velocity.x
	var acceleration: float = pda.owner.acceleration
	var speed: float = pda.owner.speed
	
	if Input.is_action_pressed("run"):
		pda.owner.velocity.x = move_toward(velocity_x, 2.0 * speed * move_direction, 2.0 * acceleration * delta)
	else:
		pda.owner.velocity.x = move_toward(velocity_x, speed * move_direction, acceleration * delta)
	
	super(delta)
