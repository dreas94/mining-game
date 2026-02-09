class_name iPlayer
extends CharacterBody2D
signal mine_attempt()

@export var animation_tree: AnimationTree
@export var camera: Camera2D

enum PlayerState {IDLE, WALK, JUMP, DOWN}
var _current_state: PlayerState = PlayerState.IDLE

var speed: float = 100.0
var acceleration: float = 100.0
var deacceleration: float = acceleration * 4.0
var jump_speed: float = -200.0
var gravity: float = 400.0


var move_direction: float
var last_facing_direction: float
var collided: bool = false


func _ready() -> void:
	#global_position.y = -World.tile_map.rendering_quadrant_size - 1.0
	animation_tree.active = true


func _physics_process(delta: float) -> void:
	_handle_input(delta)
	_handle_collision()
	_update_movement(delta)
	_update_states()
	_update_animation()
	
	move_and_slide()


func _handle_collision() -> void:
	if get_slide_collision_count() == 0:
		return
	
	for index: int in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(index)
		if collision.get_normal().x != 0:
			return


func _handle_input(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		_current_state = PlayerState.JUMP
	
	move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if move_direction == 0:
		velocity.x = move_toward(velocity.x, 0, deacceleration * delta)
	elif Input.is_action_pressed("run"):
		velocity.x = move_toward(velocity.x, 2.0 * speed * move_direction, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, speed * move_direction, acceleration * delta)


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
	
	if move_direction != 0:
		animation_tree.set("parameters/PlayerStates/Down/blend_position", move_direction)
		animation_tree.set("parameters/PlayerStates/Up/blend_position", move_direction)
		animation_tree.set("parameters/PlayerStates/Idle/blend_position", move_direction)
		animation_tree.set("parameters/PlayerStates/Run/blend_position", move_direction)
		animation_tree.set("parameters/PlayerStates/Walk/blend_position", move_direction)
		
		if Input.is_action_pressed("run"):
			time_scale = 2.0
	
	if animation_tree.get("parameters/TimeScale/scale") != time_scale:
		animation_tree.set("parameters/TimeScale/scale", time_scale)


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventMouseButton:
		if not event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			return
		
		mine_attempt.emit(25)


func _play_footstep() -> void:
	if is_on_floor():
		App.sfx.play(DefaultSoundEffects.GRAVEL)
