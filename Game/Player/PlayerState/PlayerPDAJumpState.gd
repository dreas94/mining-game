class_name PlayerPDAJumpState
extends PlayerPDAState


func on_state_pushed() -> void:
	pda.owner.velocity.y = pda.owner.jump_height
	App.sfx.play(DefaultSoundEffects.JUMP)


func physics_process(delta: float) -> void:
	if Game.state.active_state is GameStateMines:
		Health.sub_health(1.0 * delta)
	
	if pda.owner.is_on_floor():
		pop_state_from_stack()
	
	var move_direction: float = pda.owner.move_direction
	var velocity_x: float = pda.owner.velocity.x
	var acceleration: float = pda.owner.acceleration
	var speed: float = pda.owner.speed
	
	if Input.is_action_pressed("run"):
		pda.owner.velocity.x = move_toward(velocity_x, speed * move_direction, acceleration * delta)
	else:
		pda.owner.velocity.x = move_toward(velocity_x, 0.5 * speed * move_direction, acceleration * delta)
	
	super(delta)
