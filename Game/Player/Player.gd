class_name iPlayer
extends CharacterBody2D
signal mine_attempt()

@export var speed: float = 100
@export var gravity: float = 20.0
@export var jump_speed: float = -300
@export var animation_tree: AnimationTree
@export var camera: Camera2D

var last_facing_direction: Range
var _is_running: bool


func _ready() -> void:
	last_facing_direction = Range.new()
	last_facing_direction.max_value = 1.0
	last_facing_direction.min_value = -1.0
	last_facing_direction.value = last_facing_direction.max_value


func _physics_process(_delta: float) -> void:
	var velocity_value: Vector2 = Vector2.ZERO
	
	#Gravity
	velocity_value.y = self.velocity.y + gravity
	
	#Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity_value.y = jump_speed
	
	var move_direction: float = 0
	#Movement
	if Input.is_action_pressed("move_left"):
		move_direction = -1
	elif Input.is_action_pressed("move_right"):
		move_direction = 1
	
	_is_running = Input.is_action_pressed("run")
	if _is_running:
		velocity_value.x = move_direction * speed * 2.0
	else:
		velocity_value.x = move_direction * speed
	
	self.velocity = velocity_value
	
	if self.velocity.x != 0 and self.velocity.y != 0:
		last_facing_direction.value = move_direction
	
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction.value)
	animation_tree.set("parameters/Run/blend_position", last_facing_direction.value)
	animation_tree.set("parameters/Walk/blend_position", last_facing_direction.value)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventMouseButton:
		if not event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			return
		
		mine_attempt.emit(25)
