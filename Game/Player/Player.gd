class_name iPlayer
extends CharacterBody2D
signal mine_attempt_by_rid(damage: int, rid: RID)

@export var animation_player: AnimationPlayer
@export var character_sprite: Sprite2D
@export var camera: Camera2D
@export var ray_2d: RayCast2D
@export var light: AnimatedPointLight2D
@export var speed: float = 100.0
@export var acceleration: float = 100.0
@export var deacceleration: float = acceleration * 4.0
@export var gravity: float = 400.0
@export var mining_speed: float = 1.0#:
	#set(value):
		#if animation_tree != null:
			#animation_tree.set("parameters/Mining Speed/scale", value)
	#get:
		#if animation_tree == null:
			#return 1
		#return animation_tree.get("parameters/Mining Speed/scale")


var _pda: PlayerPDA = PlayerPDA.new(self)
var alive: BoolAttribute = BoolAttribute.new(true)
var _grid_position: Vector2i
var previous_move_direction: float = 0.0
var move_direction: float = 1.0
var _last_tile_grid_pos_ray_casted: Vector2i = Vector2i.MAX


func _ready() -> void:
	
	light.base_scale = remap(Health.current, 0.0, UpgradeConstants.HEALTH_BASE, 0.0, 0.5)
	
	Health.current_changed.connect(_on_current_health_changed)
	alive.changed.connect(_on_alive_changed)


func _physics_process(delta: float) -> void:
	if alive.value == false:
		return
	_grid_position = Mines.breakable_tile_map_layer.translate_to_grid_positon(global_position)
	if _previous_move_direction != _move_direction:
		_previous_move_direction = _move_direction
		
	_move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	_handle_ray_cast()
	_handle_collision()
	_handle_input(delta)
	_update_movement(delta)
	
	_update_states()
	_update_animation()
	_update_health(delta)
	
	move_and_slide()


func _recover_pickaxe() -> void:
	if Input.is_action_pressed("mouse_left"):
		_current_pickaxe_state = PickaxeState.READY
	else:
		_current_pickaxe_state = PickaxeState.IDLE


func _enter_pickaxe_recovery() -> void:
	_current_pickaxe_state = PickaxeState.RECOVER


func _attempt_to_mine_by_rid(rid_to_mine: RID) -> void:
	Health.sub_health(randf_range(1.0, 5.0))
	_current_pickaxe_state = PickaxeState.SWING
	var damage: float = UpgradeCollection.calculate_upgrades(UpgradeConstants.TYPE.DAMAGE)
	mine_attempt_by_rid.emit(damage, rid_to_mine)
	print("Pickaxe struck")


func _handle_ray_cast() -> void:
	if Game.state.active_state is GameStateCamp:
		return
	var previous_tile: Tile = Mines.tile_handler.get_tile_in_grid_position(_last_tile_grid_pos_ray_casted)
	if not ray_2d.is_colliding():
		if previous_tile == null:
			return
		previous_tile.tile_attributes.is_moused.value = false
		_last_tile_grid_pos_ray_casted =  Vector2i.MAX
		return
	
	if _current_pickaxe_state == PickaxeState.SWING:
		return
	
	var tile: Tile = Mines.tile_handler.get_tile_based_on_rid(ray_2d.get_collider_rid())
	
	if tile == null:
		return
	
	if previous_tile == tile:
		return
	
	tile.tile_attributes.is_moused.value = true
	_last_tile_grid_pos_ray_casted =  Mines.tile_handler.get_grid_position_of_tile(tile)
	
	if previous_tile == null:
		return
		
	previous_tile.tile_attributes.is_moused.value = false
	_last_tile_grid_pos_ray_casted = Mines.tile_handler.get_grid_position_of_tile(tile)
	


func _handle_collision() -> void:
	if not ray_2d.is_colliding():
		return
	
	if _current_pickaxe_state != PickaxeState.READY:
		return
	
	_attempt_to_mine_by_rid(ray_2d.get_collider_rid())


func _handle_input(delta: float) -> void:
	if Game.state.active_state is GameStateMines:
		match _current_pickaxe_state:
			PickaxeState.IDLE when Input.is_action_pressed("mouse_left"):
				_current_pickaxe_state = PickaxeState.READY
			PickaxeState.READY when not Input.is_action_pressed("mouse_left"):
				_current_pickaxe_state = PickaxeState.IDLE
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = UpgradeCollection.calculate_upgrades(UpgradeConstants.TYPE.JUMP_HEIGHT)
		App.sfx.play(DefaultSoundEffects.JUMP)
		_current_state = PlayerState.JUMP
	if _move_direction == 0:
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
			if _move_direction != 0:
				_current_state = PlayerState.WALK
		PlayerState.WALK:
			if _move_direction == 0:
				_current_state = PlayerState.IDLE
				if _previous_move_direction > 0.0:
					animation_player.stop()
					animation_player.play("Idle_Right")
				elif _previous_move_direction < 0.0:
					animation_player.stop()
					animation_player.play("Idle_Left")
			elif _move_direction != _previous_move_direction:
				if _move_direction > 0.0:
					print("Playing Walk Right")
					animation_player.stop()
					animation_player.play("Walk_Right")
				elif _move_direction < 0.0:
					print("Playing Walk Left")
					animation_player.stop()
					animation_player.play("Walk_Left")
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
		#animation_tree.set("parameters/Mining/Idle/blend_position", _move_direction)
		#animation_tree.set("parameters/Mining/Ready/blend_position", _move_direction)
		#animation_tree.set("parameters/Mining/Mining/blend_position", _move_direction)
		#animation_tree.set("parameters/PlayerStates/Crouch/blend_position", _move_direction)
		#animation_tree.set("parameters/PlayerStates/Down/blend_position", _move_direction)
		#animation_tree.set("parameters/PlayerStates/Up/blend_position", _move_direction)
		#animation_tree.set("parameters/PlayerStates/Idle/blend_position", _move_direction)
		#animation_tree.set("parameters/PlayerStates/Run/blend_position", _move_direction)
		#animation_tree.set("parameters/PlayerStates/Walk/blend_position", _move_direction)
		
		if Input.is_action_pressed("run"):
			time_scale = 2.0
	
	mining_speed = UpgradeCollection.calculate_upgrades(UpgradeConstants.TYPE.MINING_SPEED)
	
	#if animation_tree.get("parameters/TimeScale/scale") != time_scale:
		#animation_tree.set("parameters/TimeScale/scale", time_scale)


func _update_health(delta: float) -> void:
	if not Game.state.active_state is GameStateMines:
		return
	match _current_state:
		PlayerState.IDLE:
			pass
		_:
			Health.sub_health(1.0 * delta)



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var global_mouse_pos: Vector2 = get_global_mouse_position()
		var local_mouse_pos: Vector2 = to_local(global_mouse_pos)
		var normalized_local_mouse_pos: Vector2 = local_mouse_pos.normalized()
		var direction: Vector2 = Vector2.ZERO
		var shortest_distance: float = INF
		for vec: Vector2 in [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]:
			var distance: float = vec.distance_to(normalized_local_mouse_pos)
			if shortest_distance < distance:
				continue
			direction = vec
			shortest_distance = distance
		
		ray_2d.target_position = direction * 16.0


func _play_footstep() -> void:
	if is_on_floor():
		App.sfx.play(DefaultSoundEffects.GRAVEL)


func _on_current_health_changed(_previous: float, current: float) -> void:
	light.base_scale = remap(current, 0.0, UpgradeConstants.HEALTH_BASE, 0.0, 0.5)


func _on_alive_changed(current: bool, _previous: bool) -> void:
	if current == true:
		return
	var tile: Tile = Mines.tile_handler.get_tile_in_grid_position(_last_tile_grid_pos_ray_casted)
	if tile == null:
		return
	
	_current_state = PlayerState.IDLE
	tile.tile_attributes.is_moused.value = false
