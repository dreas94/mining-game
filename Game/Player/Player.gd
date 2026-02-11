class_name iPlayer
extends CharacterBody2D
signal mine_attempt(damage: int, rid: RID)

@export var animation_tree: AnimationTree
@export var camera: Camera2D
@export var speed: float = 100.0
@export var acceleration: float = 100.0
@export var deacceleration: float = acceleration * 4.0
@export var jump_speed: float = -200.0
@export var gravity: float = 400.0
@export var mining_speed: float = 1.0


enum PlayerState {IDLE, WALK, JUMP, DOWN}
var _current_state: PlayerState = PlayerState.IDLE

var _knockback_value: Vector2 = Vector2.ZERO
var _knock_back_tween: Tween
var _move_direction: float


func _ready() -> void:
	#global_position.y = -World.tile_map.rendering_quadrant_size - 1.0
	animation_tree.active = true


func _physics_process(delta: float) -> void:
	_move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	_handle_collision()
	_handle_input(delta)
	_update_movement(delta)
	if _knockback_value.y > 0.0:
		velocity += Vector2(_knockback_value.x, 0.0)
	elif _knockback_value.x != 0.0:
		velocity.x = 0.0
		velocity += _knockback_value
	else:
		velocity += _knockback_value
	_update_states()
	_update_animation()
	
	move_and_slide()


func _handle_collision() -> void:
	if get_slide_collision_count() == 0:
		return
	
	if _knockback_value != Vector2.ZERO:
		return
	
	if _knock_back_tween != null and _knock_back_tween.is_running():
		return
	
	if not Input.is_action_pressed("mouse_left"):
		return
	
	var already_triggered_rid: Array[RID]
	for index: int in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(index)
		if already_triggered_rid.find(collision.get_collider_rid()) != -1:
			continue 
		if collision.get_normal().x != 0 and collision.get_normal().x == -_move_direction:
			already_triggered_rid.append(collision.get_collider_rid())
			mine_attempt.emit(25, already_triggered_rid.back())
			apply_knockback(collision.get_normal(), 10.0, mining_speed)
		elif collision.get_normal().y > 0.0 and _current_state == PlayerState.JUMP:
			already_triggered_rid.append(collision.get_collider_rid())
			mine_attempt.emit(25, already_triggered_rid.back())
			apply_knockback(collision.get_normal(), 8.0, mining_speed)
		elif is_on_floor() and collision.get_normal().y < 0.0 and Input.is_action_pressed("move_down"):
			already_triggered_rid.append(collision.get_collider_rid())
			mine_attempt.emit(25, already_triggered_rid.back())
			apply_knockback(collision.get_normal(), 8.0, mining_speed)


func _handle_input(delta: float) -> void:
	if _knockback_value != Vector2.ZERO:
		velocity.x = 0.0
		return
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		_current_state = PlayerState.JUMP
	
	if _move_direction == 0:
		velocity.x = move_toward(velocity.x, 0, deacceleration * delta)
	else:
		if Input.is_action_pressed("run"):
			velocity.x = move_toward(velocity.x, 2.0 * speed * _move_direction, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, speed * _move_direction, acceleration * delta)


func _update_movement(delta: float) -> void:
	#Gravity
	if is_on_floor():
		return
	
	velocity.y += gravity * delta


func _update_states() -> void:
	match _current_state:
		PlayerState.IDLE when velocity.x != 0:
			_current_state = PlayerState.WALK
		PlayerState.WALK:
			if velocity.x == 0:
				_current_state = PlayerState.IDLE
			if not is_on_floor() && velocity.y > 0:
				_current_state = PlayerState.DOWN
		PlayerState.JUMP when velocity.y > 0:
			_current_state = PlayerState.DOWN
		PlayerState.DOWN when is_on_floor():
			if velocity.x == 0:
				_current_state = PlayerState.IDLE
			else:
				_current_state = PlayerState.WALK


func _update_animation() -> void:
	var time_scale: float = 1.0
	
	if _move_direction != 0:
		animation_tree.set("parameters/PlayerStates/Down/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Up/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Idle/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Run/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Walk/blend_position", _move_direction)
		
		if Input.is_action_pressed("run"):
			time_scale = 2.0
	
	if animation_tree.get("parameters/TimeScale/scale") != time_scale:
		animation_tree.set("parameters/TimeScale/scale", time_scale)


func apply_knockback(direction: Vector2, force: float, duration: float) -> void:
	print("Knockback applied towards " + str(direction))
	
	if direction.x != 0.0 and direction.y != 0.0:
		breakpoint
	_knockback_value = direction * force
	
	_knock_back_tween = create_tween()
	_knock_back_tween.set_parallel()
	_knock_back_tween.tween_property(self, "_knockback_value", Vector2.ZERO, duration)


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventMouseButton:
		if not event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			return


func _play_footstep() -> void:
	if is_on_floor():
		App.sfx.play(DefaultSoundEffects.GRAVEL)
