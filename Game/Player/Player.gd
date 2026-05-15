class_name iPlayer
extends CharacterBody2D
@warning_ignore("unused_signal")
signal mine_attempt_by_rid(damage: int, rid: RID)

@export var animation_player: AnimationPlayer
@export var character_sprite: Sprite2D
@export var pickaxe_sprite: Sprite2D
@export var camera: Camera2D
@export var ray_2d: RayCast2D
@export var light: AnimatedPointLight2D
@export var speed: float = 100.0
@export var acceleration: float = 100.0
@export var deacceleration: float = acceleration * 4.0
@export var gravity: float = 400.0

var _pickaxe_pda: PickaxePDA = PickaxePDA.new(self)
var _pda: PlayerPDA = PlayerPDA.new(self)
var alive: BoolAttribute = BoolAttribute.new(true)
var last_tile_grid_pos_ray_casted: Vector2i = Vector2i.MAX
var previous_move_direction: float = 0.0
var move_direction: float = 1.0


func _ready() -> void:
	_pda.push_state_to_stack(PlayerPDAIdleState.new())
	_pickaxe_pda.push_state_to_stack(PickaxePDAIdleState.new())
	light.base_scale = remap(Health.current, 0.0, UpgradeConstants.HEALTH_BASE, 0.0, 0.5)
	
	Health.current_changed.connect(_on_current_health_changed)
	alive.changed.connect(_on_alive_changed)


func _physics_process(delta: float) -> void:
	if alive.value == false:
		return
	
	if previous_move_direction != move_direction:
		previous_move_direction = move_direction
		
	move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	_handle_ray_cast()
	_pda.physics_update(delta)
	_pickaxe_pda.physics_update(delta)


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
	_pda.clear_stack()


func _handle_ray_cast() -> void:
	if Game.state.active_state is GameStateCamp:
		return
	
	if _pickaxe_pda.state_stack[-1] is PickaxePDASwingState:
		return
	
	var previous_tile: Tile = Mines.tile_handler.get_tile_in_grid_position(last_tile_grid_pos_ray_casted)
	if not ray_2d.is_colliding():
		if previous_tile == null:
			return
		previous_tile.tile_attributes.is_moused.value = false
		last_tile_grid_pos_ray_casted =  Vector2i.MAX
		return
	
	var tile: Tile = Mines.tile_handler.get_tile_based_on_rid(ray_2d.get_collider_rid())
	
	if tile == null:
		return
	
	if previous_tile == tile:
		return
	
	tile.tile_attributes.is_moused.value = true
	last_tile_grid_pos_ray_casted =  Mines.tile_handler.get_grid_position_of_tile(tile)
	
	if previous_tile == null:
		return
		
	previous_tile.tile_attributes.is_moused.value = false
	last_tile_grid_pos_ray_casted = Mines.tile_handler.get_grid_position_of_tile(tile)
