class_name iPlayer
extends CharacterBody2D
signal mine_attempt_by_rid(damage: int, rid: RID)

@export var animation_tree: AnimationTree
@export var camera: Camera2D
@export var speed: float = 100.0
@export var acceleration: float = 100.0
@export var deacceleration: float = acceleration * 4.0
@export var jump_speed: float = -200.0
@export var gravity: float = 400.0
@export var mining_speed: float = 1.0:
	set(value):
		if animation_tree != null:
			animation_tree.set("parameters/Mining Speed/scale", value)
	get:
		if animation_tree == null:
			return 1
		return animation_tree.get("parameters/Mining Speed/scale")


enum PlayerState {IDLE, WALK, JUMP, DOWN, CROUCH}
enum PickaxeState {IDLE, READY, SWING, RECOVER}
var _current_state: PlayerState = PlayerState.IDLE
var _current_pickaxe_state: PickaxeState = PickaxeState.IDLE
var _grid_position: Vector2i
var _move_direction: float = 1.0


func _ready() -> void:
	animation_tree.active = true
	
	animation_tree.set("parameters/Mining/Idle/blend_position", 1.0)
	animation_tree.set("parameters/Mining/Ready/blend_position", 1.0)
	animation_tree.set("parameters/Mining/Mining/blend_position", 1.0)
	animation_tree.set("parameters/PlayerStates/Crouch/blend_position", 1.0)
	animation_tree.set("parameters/PlayerStates/Down/blend_position", 1.0)
	animation_tree.set("parameters/PlayerStates/Up/blend_position", 1.0)
	animation_tree.set("parameters/PlayerStates/Idle/blend_position", 1.0)
	animation_tree.set("parameters/PlayerStates/Run/blend_position", 1.0)
	animation_tree.set("parameters/PlayerStates/Walk/blend_position", 1.0)


func _physics_process(delta: float) -> void:
	_grid_position = World.breakable_tile_map_layer.translate_to_grid_positon(global_position)
	_move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	_handle_collision()
	_handle_input(delta)
	_update_movement(delta)
	
	_update_states()
	_update_animation()
	
	move_and_slide()


func _recover_pickaxe() -> void:
	if Input.is_action_pressed("mouse_left"):
		_current_pickaxe_state = PickaxeState.READY
	else:
		_current_pickaxe_state = PickaxeState.IDLE


func _enter_pickaxe_recovery() -> void:
	_current_pickaxe_state = PickaxeState.RECOVER


func _attempt_to_mine_by_rid(rid_to_mine: RID) -> void:
	_current_pickaxe_state = PickaxeState.SWING
	mine_attempt_by_rid.emit(25, rid_to_mine)
	print("Pickaxe struck")


func _handle_collision() -> void:
	var collision_count: int = get_slide_collision_count()
	if collision_count == 0:
		return
	if collision_count > 1:
		print(str(collision_count))
		
	if _current_pickaxe_state != PickaxeState.READY:
		return
	
	var picked_collision: KinematicCollision2D = null
	var already_triggered_rid: Array[RID]
	for index: int in range(collision_count):
		var collision: KinematicCollision2D = get_slide_collision(index)
		if already_triggered_rid.find(collision.get_collider_rid()) != -1:
			continue
		match _current_state:
			PlayerState.CROUCH when is_on_floor() and collision.get_normal().y < 0.0:
				if picked_collision == null:
					picked_collision = collision
				elif collision.get_normal().y > picked_collision.get_normal().y:
					picked_collision = collision
				elif collision.get_normal().x < picked_collision.get_normal().x:
					picked_collision = collision
			PlayerState.JUMP when not is_on_floor() and collision.get_normal().y > 0.0:
				picked_collision = collision
			PlayerState.DOWN when not is_on_floor() and collision.get_normal().y > 0.0:
				picked_collision = collision
			_ when collision.get_normal().x != 0 and collision.get_normal().x == -_move_direction:
				picked_collision = collision
	
	if picked_collision == null:
		return
	_attempt_to_mine_by_rid(picked_collision.get_collider_rid())


func _handle_input(delta: float) -> void:
	match _current_pickaxe_state:
		PickaxeState.IDLE when Input.is_action_pressed("mouse_left"):
			_current_pickaxe_state = PickaxeState.READY
		PickaxeState.READY when not Input.is_action_pressed("mouse_left"):
			_current_pickaxe_state = PickaxeState.IDLE
	
	if _current_state != PlayerState.CROUCH and Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		App.sfx.play(DefaultSoundEffects.JUMP)
		_current_state = PlayerState.JUMP
	if _current_state != PlayerState.JUMP and Input.is_action_pressed("move_down") and is_on_floor():
		_current_state = PlayerState.CROUCH
		velocity.x = move_toward(velocity.y, 0.1 * speed * _move_direction, acceleration * delta)
		velocity.x = move_toward(velocity.x, 0.1 * speed * _move_direction, acceleration * delta)
	elif _move_direction == 0:
		velocity.x = move_toward(velocity.x, 0.0, deacceleration * delta)
	else:
		if Input.is_action_pressed("run"):
			velocity.x = move_toward(velocity.x, speed * _move_direction, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.5 * speed * _move_direction, acceleration * delta)


func _update_movement(delta: float) -> void:
	#Gravity
	if is_on_floor():
		return
	
	velocity.y += gravity * delta


func _update_states() -> void:
	match _current_state:
		PlayerState.IDLE:
			if velocity.x != 0:
				_current_state = PlayerState.WALK
		PlayerState.WALK:
			if velocity.x == 0:
				_current_state = PlayerState.IDLE
			if not is_on_floor() && velocity.y > 0:
				_current_state = PlayerState.DOWN
		PlayerState.JUMP when velocity.y > 0:
			_current_state = PlayerState.DOWN
		PlayerState.CROUCH when not Input.is_action_pressed("move_down"):
			if is_on_floor() and velocity.x == 0:
				_current_state = PlayerState.IDLE
			elif is_on_floor() and velocity.x != 0:
				_current_state = PlayerState.WALK
		PlayerState.DOWN when is_on_floor():
			if velocity.x == 0:
				_current_state = PlayerState.IDLE
			else:
				_current_state = PlayerState.WALK


func _update_animation() -> void:
	var time_scale: float = 1.0
	
	if _move_direction != 0:
		animation_tree.set("parameters/Mining/Idle/blend_position", _move_direction)
		animation_tree.set("parameters/Mining/Ready/blend_position", _move_direction)
		animation_tree.set("parameters/Mining/Mining/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Crouch/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Down/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Up/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Idle/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Run/blend_position", _move_direction)
		animation_tree.set("parameters/PlayerStates/Walk/blend_position", _move_direction)
		
		if Input.is_action_pressed("run"):
			time_scale = 2.0
	
	if animation_tree.get("parameters/TimeScale/scale") != time_scale:
		animation_tree.set("parameters/TimeScale/scale", time_scale)


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventMouseMotion:
		if not event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			return


func _play_footstep() -> void:
	if is_on_floor():
		App.sfx.play(DefaultSoundEffects.GRAVEL)
