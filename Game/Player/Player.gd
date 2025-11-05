class_name iPlayer
extends CharacterBody2D

@export var speed: float = 100
@export var animation_tree: AnimationTree

var last_facing_direction: Range
var _is_running: bool


func _ready() -> void:
	last_facing_direction = Range.new()
	last_facing_direction.max_value = 1.0
	last_facing_direction.min_value = -1.0
	last_facing_direction.value = last_facing_direction.max_value


func _physics_process(_delta: float) -> void:
	_is_running = Input.is_action_pressed("run")
	
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var velocity_value: Vector2 = input_direction * speed
	
	if _is_running:
		velocity_value *= 2.0
	
	self.velocity = velocity_value
	
	var idle: bool = !self.velocity
	
	if !idle:
		last_facing_direction.value = input_direction.x
	
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction.value)
	animation_tree.set("parameters/Run/blend_position", last_facing_direction.value)
	animation_tree.set("parameters/Walk/blend_position", last_facing_direction.value)
	move_and_slide()
